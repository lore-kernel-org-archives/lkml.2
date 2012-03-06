Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030859Ab2CFTxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 14:53:18 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:58092 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965254Ab2CFTxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 14:53:15 -0500
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1/V2IJy3AfVCJydKQqpxBKtMhPn9v8pm5kfxBva/k
	994VjqnechXI6n
From: Sven Joachim <svenjoac@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stefan Lippers-Hollmann <s.L-H@gmx.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-wireless@vger.kernel.org,
        Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [ 57/72] genirq: Unmask oneshot irqs when thread was not woken
References: <20120228010511.GA8453@kroah.com>
	<20120228010434.412979550@linuxfoundation.org>
	<87hay4dqjr.fsf@turtle.gmx.de> <201203050143.24541.s.L-H@gmx.de>
	<CA+55aFxZsVxkxifR+EUZi=RsUGKfs5vYXX3nN_M_Az1BY5yyaw@mail.gmail.com>
	<alpine.LFD.2.02.1203060927190.2742@ionos>
	<alpine.LFD.2.02.1203060957140.2742@ionos>
	<alpine.LFD.2.02.1203062019340.2742@ionos>
Date: Tue, 06 Mar 2012 20:53:10 +0100
In-Reply-To: <alpine.LFD.2.02.1203062019340.2742@ionos> (Thomas Gleixner's
	message of "Tue, 6 Mar 2012 20:31:46 +0100 (CET)")
Message-ID: <8762eh1p7d.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.03.2012 um 20:31 schrieb Thomas Gleixner:

> Stephan, Sven: Can you please provide the output of /proc/interrupts ?

Here is mine, from a freshly booted 3.3-rc6 kernel.

Cheers,
       Sven

           CPU0       
  0:      25050    XT-PIC-XT-PIC    timer
  1:        101    XT-PIC-XT-PIC    i8042
  2:          0    XT-PIC-XT-PIC    cascade
  3:          1    XT-PIC-XT-PIC  
  4:          1    XT-PIC-XT-PIC  
  5:          0    XT-PIC-XT-PIC    ehci_hcd:usb1, uhci_hcd:usb2
  6:          1    XT-PIC-XT-PIC    i915, uhci_hcd:usb5, yenta
  7:          1    XT-PIC-XT-PIC  
  8:          0    XT-PIC-XT-PIC    rtc0
  9:        634    XT-PIC-XT-PIC    acpi
 10:        341    XT-PIC-XT-PIC    uhci_hcd:usb4, snd_hda_intel, b43
 11:          0    XT-PIC-XT-PIC    uhci_hcd:usb3
 12:        144    XT-PIC-XT-PIC    i8042
 14:       4141    XT-PIC-XT-PIC    ata_piix
 15:          0    XT-PIC-XT-PIC    ata_piix
NMI:          0   Non-maskable interrupts
MCE:          0   Machine check exceptions
MCP:          1   Machine check polls
ERR:          0

