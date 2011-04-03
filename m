Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab1DCOf1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 10:35:27 -0400
Received: from ist.d-labs.de ([213.239.218.44]:60853 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab1DCOfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 10:35:24 -0400
Date: Sun, 3 Apr 2011 16:34:49 +0200
From: Florian Mickler <florian@mickler.org>
To: linux-kernel@vger.kernel.org
Cc: Florian Mickler <florian@mickler.org>, mingo@elte.hu,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, rjw@sisk.pl, sedat.dilek@gmail.com
Subject: Re: [PATCH] x86, ioapic: move acpi_get_override_irq to acpi.c
Message-ID: <20110403163449.33a6a4dc@schatten.dmk.lab>
In-Reply-To: <20110401182653.340abaa4@schatten.dmk.lab>
References: <20110401075011.GD7594@elte.hu>
	<1301672686-10096-1-git-send-email-florian@mickler.org>
	<20110401182653.340abaa4@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Apr 2011 18:26:53 +0200
Florian Mickler <florian@mickler.org> wrote:

> And how do I check compilation of !CONFIG_X86_IO_APIC?  

That was a real question, btw. Not just me mumbling around... make
oldconfig always turns that symbol back on to =y ... and I couldn't find
out why. 

> Regards,
> Flo
