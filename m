Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab1ECQgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:36:43 -0400
Received: from legolas.restena.lu ([158.64.1.34]:45812 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab1ECQgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:36:42 -0400
Date: Tue, 3 May 2011 18:36:27 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Franco =?UTF-8?B?R2FzdMOzbg==?= Pellegrini 
	<francogpellegrini@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: unable to enumerate USB device on port 6
Message-ID: <20110503183627.3c7cffa1@neptune.home>
In-Reply-To: <BANLkTimjOA2LiR7uy+jsHMtkMuovGuGaBQ@mail.gmail.com>
References: <BANLkTimjOA2LiR7uy+jsHMtkMuovGuGaBQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 May 2011 Franco Gastón Pellegrini  <francogpellegrini@gmail.com> wrote:
> Kernel version: 2.6.38-8-generic #42-Ubuntu SMP Mon Apr 11 03:31:24
> UTC 2011 x86_64 x86_64 x86_64 GNU/Linux
> 
> hi,
> I have an ACER 5520, with ubuntu 11.04 and all my TTY repeats
> indefinitly (every 1/3 seconds) the mesages:

What is connected to your Acer (laptop?) via USB? (include built-in 
card readers and bluetooth!)

I had my Acer TM660 laptop spit similar messages at some occasions
because of aging contacts between card reader and mainboard.
Taking off card reader, cleaning contacts and putting everything back
together fixed the issue here.


On the other hand it should not prevent you from using your computer
unless your keyboard was connected to that specific port (instead of
being PS/2 internally).

Bruno


> .....
> May 1 18:34:27 franco-Aspire-5520 kernel: [ 888.350128] hub 1-0:1.0:
> unable to enumerate USB device on port 6
> May 1 18:34:27 franco-Aspire-5520 kernel: [ 888.610230] hub 3-0:1.0:
> unable to enumerate USB device on port 6
> May 1 18:34:27 franco-Aspire-5520 kernel: [ 888.890098] hub 1-0:1.0:
> unable to enumerate USB device on port 6
> May 1 18:34:28 franco-Aspire-5520 kernel: [ 889.150111] hub 3-0:1.0:
> unable to enumerate USB device on port 6
> ....
> 
> i cant use any TTY, how can i fix it? any kernel before do this for me.
> 
> PD: what info do you need to complete my report?
> 
> Excuse my english
