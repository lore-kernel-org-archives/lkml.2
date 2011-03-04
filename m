Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017Ab1CDSgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:36:40 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:51696 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759729Ab1CDSgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:36:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qxg4wLrSSpAjEgaYM4T+H99Csx9HMY+cqf1j8Hfr3JvoBBw1C4/zwsKKcIHoe7zX5zi8C8Vu3qXhxbzdsVoAoVhPPLVHdlurnAf+io3ckYTOuzTbcCYdFhv+++Z1siXI;
Date: Fri, 4 Mar 2011 10:36:34 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Micha Nelissen <micha@neli.hopto.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Add support for multiple MSI on x86
Message-ID: <20110304103634.4641ae36@jbarnes-desktop>
In-Reply-To: <4D583E31.4070507@neli.hopto.org>
References: <4D583E31.4070507@neli.hopto.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Feb 2011 21:25:21 +0100
Micha Nelissen <micha@neli.hopto.org> wrote:

> Patch is based on earlier patch from Matthew Wilcox.

I like this before when Matthew was working on it too; Matthew can you
give it a look?  I'd have to dig through the archives to see why we
didn't apply it before (maybe lack of device support?  if so, it sounds
like this patch addresses that issue, since Micha has a device in mind).

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
