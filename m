Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab0I1RSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:18:32 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:54835 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756929Ab0I1RSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:18:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=mnZF483ZGzcLtqQSsNuhax/vEq1XpxnLt8ZsrUsgmG1NH1FcMU/NIN7Xk5FEGSSdz/jheUrYpT8wSqnfeGhzXnVGRaHC4wLxKrrGAyhyZ/OmA+OvQU99d7+l45KYIGYs;
Date: Tue, 28 Sep 2010 10:18:24 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: tim.gardner@canonical.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: MCP limit log messages, 2.6.36-rc4
Message-ID: <20100928101824.7dd1a44e@jbarnes-desktop>
In-Reply-To: <4CA2190D.4010205@canonical.com>
References: <4C9106C1.4080505@canonical.com>
	<20100923134816.57e932fc@jbarnes-desktop>
	<20100923145428.4805adcb@jbarnes-desktop>
	<4C9BD8D5.7080201@canonical.com>
	<20100924091820.4f649786@jbarnes-desktop>
	<4CA2190D.4010205@canonical.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010 10:34:21 -0600
Tim Gardner <tim.gardner@canonical.com> wrote:

> On 09/24/2010 10:18 AM, Jesse Barnes wrote:
> > On Fri, 24 Sep 2010 06:46:45 +0800
> > Tim Gardner<tim.gardner@canonical.com>  wrote:
> >> Its just a debug hack which I wrote (that I mentioned in the first
> >> email) so I could figure out why the driver was complaining.
> >
> > Oh sorry, missed that.  An upstream patch for that would be welcome as
> > well.
> >
> >> I'll be back from Asia by Monday and will give these patches a try.
> >
> > Great, as I said you may still see spurious "over power" conditions,
> > but that's due to a bug in the i915 driver.
> >
> 
> With these 3 patches applied the MCP log message noise goes away. The 
> 4th patch (also applied) is the debug patch mentioned in my first email 
> (if you're still interested in it). This is on top of Linus tree at 
> 830c55a673537ca33ef4689fb5f20c2d66d98519 (plus some Ubuntu cruft).
> 
> The only 'intel ips' messages left in the log are these:
> 
> intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match expected value 
> (found 25, expected 35)
> intel ips 0000:00:1f.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 95

All looks good.

Patch is a nice improvement too; please send it over to the x86
platform driver list and cc Matthew Garrett so he can apply it.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
