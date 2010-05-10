Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0EJVZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:25:58 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:46823 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751754Ab0EJVZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:25:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=YIellI97/TNp6mCmym6FaShpolDQQtkQipUKmyA1trPBG9Dbz/7CZdOnS49OzaJWDw2Qfidz9xv6sQRpWP0fVYXMbRluAAFFPorTHFcKiBL9/+jcT+NCP/9q73dY03GL;
Date: Mon, 10 May 2010 14:25:21 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Intelligent power sharing driver
Message-ID: <20100510142521.5a705dea@virtuousgeek.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds the core IPS driver to drivers/platform/x86, along
with some helper code in the timer subsystem to allow for deferrable
on-stack timers.

Note that this patchset doesn't include the i915 specific bits for
monitoring power consumption.  We're doing final validation on those
now so I expect to be able to post them soon.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
