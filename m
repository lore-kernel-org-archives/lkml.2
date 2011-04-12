Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab1DLP4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:56:38 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:57639 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757921Ab1DLP4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:56:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=sDvgLUWNd/OZi03ahRqo2kmlgRDc7WclfCYy2rBa7y4RE1BSM2Ax/oPVlQrkybjj6cbY+8kUgdBfEYGZiH1KTxauPQzzI7cKw5yzLWqBKxhKtBhE6Fo8bg7RjtwNxm+n;
Date: Tue, 12 Apr 2011 08:56:22 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, Robert Hancock <hancockrwd@gmail.com>,
        mjg59@srcf.ucam.org, lenb@kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] ACPI: pci_irq, add PRT_ quirk for IBM Bartolo
Message-ID: <20110412085622.43488ed9@jbarnes-desktop>
In-Reply-To: <1302598086-3622-1-git-send-email-jslaby@suse.cz>
References: <4C87A62E.30108@gmail.com>
	<1302598086-3622-1-git-send-email-jslaby@suse.cz>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011 10:48:06 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> On IBM Bartolo machines, cards in 00:09.0 are defunct (if use
> interrupts). DSDT says that this slot (with function 0, i.e. pin A) is
> routed to \_SB_.PCI0.PIB_.LNKB. But it's not, it's wired to LNKC, so
> interrupts are misrouted. Add a quirk for this to workaround the
> issue.
> 
> References: https://bugzilla.novell.com/show_bug.cgi?id=595683
> References: https://bugzilla.kernel.org/show_bug.cgi?id=18092
> 
> ---
> Hi,
> 
> as Robert Hancock suggested at:
> http://lkml.org/lkml/2010/9/7/206
> 
> I reported this in bugzilla (the link above). But I got only replies
> requesting another infos which I provided. Could anybody look into
> the bug and confirm whether this patch is correct or not. And if yes,
> could you apply that?

I'll defer to the ACPI experts, Len or Matthew have you checked this
one out?

-- 
Jesse Barnes, Intel Open Source Technology Center
