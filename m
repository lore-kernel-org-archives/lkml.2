Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab0HYBhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 21:37:13 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:34109 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752037Ab0HYBhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 21:37:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=UrowTb/Gm/7i1nmjUlKc0wsG+Ttq0WfrzSD3+S/xT1C/IzW8V1IddlPKi3fVw1PVY/zcRn1m7ZDv4o2Zb/LukRl9ZI8/3+SaqqC2BhP5HTy5WWlNSYAcsnY/Ejm8tjfm;
Date: Tue, 24 Aug 2010 18:37:06 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: intel ips: CPU TDP doesn't match expected value
Message-ID: <20100824183706.27645aa1@virtuousgeek.org>
In-Reply-To: <4C74686D.8090707@cesarb.net>
References: <4C74686D.8090707@cesarb.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 21:48:45 -0300
Cesar Eduardo Barros <cesarb@cesarb.net> wrote:

> I get the following messages on v2.6.36-rc2-203-g502adf5:
> 
> intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match expected value 
> (found 25, expected 35)
> intel ips 0000:00:1f.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 65535
> intel ips 0000:00:1f.6: MCP power or thermal limit exceeded
> intel ips 0000:00:1f.6: CPU power or thermal limit exceeded
> 
> (The last two messages repeat very often, one of them every five 
> seconds; if I understand it correctly, that is normal and expected.)
> 
> The code implies the "CPU TDP doesn't match expected value" is a sanity 
> check failing. Should that happen, or is there something wrong?

Yeah, it's normal, and should probably be downgraded to an
informational message.  It just means your BIOS doesn't want you to
push the CPU all the way up to its maximum TDP, probably because the
platform or chassis wasn't designed for that much heat or power
consumption.

-- 
Jesse Barnes, Intel Open Source Technology Center
