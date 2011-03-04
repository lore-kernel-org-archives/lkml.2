Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022Ab1CDShc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:37:32 -0500
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:36249 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759729Ab1CDShb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:37:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=IgNclrje9OsHrr6p1HG24r3w+L4aQONQKFR8ulOJUOtNARK1na/xakdOa/JbRxCv1tHIh+pzyKAWHS0fTwNXgELIgkEZt+GBnkLWp67THdHB9D79SjYOnQIMg3mKOXHr;
Date: Fri, 4 Mar 2011 10:37:26 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Micha Nelissen <micha@neli.hopto.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Add support for multiple MSI on x86
Message-ID: <20110304103726.638afe3c@jbarnes-desktop>
In-Reply-To: <alpine.LFD.2.00.1102142106560.26192@localhost6.localdomain6>
References: <4D583E31.4070507@neli.hopto.org>
	<alpine.LFD.2.00.1102142106560.26192@localhost6.localdomain6>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011 21:55:33 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sun, 13 Feb 2011, Micha Nelissen wrote:
> 
> > Patch is based on earlier patch from Matthew Wilcox.
> 
> Please do not attach patches. Send them inline.

(I assume you're looking at Thomas's feedback as well...)

-- 
Jesse Barnes, Intel Open Source Technology Center
