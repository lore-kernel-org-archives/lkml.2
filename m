Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab0DSFfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 01:35:50 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:58633 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0DSFft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 01:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:to:cc:in-reply-to:references;
        b=ZMzmEOmYfyxhYz7TyCScRdsWOOPvN3l2j6FIBAGOu2Hi4FKuFMuV0JRLPgNwTlzdIp
         Bnt/Sh3LiDL+PNp0lCd/DiWYORiWcPbEFePALg8lTAgHB8Mp37VG4fJlZwid5bmocdgb
         5yCrsmcf6tL7WdZOrLY2zq48K978svM7dnRzc=
Message-ID: <4bcbebb3.9653f10a.3be1.ffffe0ef@mx.google.com>
Date: Sun, 18 Apr 2010 22:35:47 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: gcc- 4.6.0 20100416 rtmutex.c:1138:1: internal compiler error
To: Justin Mattock <justinmattock@gmail.com>, gcc@gcc.gnu.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <i2ydd18b0c31004182119w30322238p2ab0094f55901051@mail.gmail.com>
References: <i2ydd18b0c31004182119w30322238p2ab0094f55901051@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Apr 2010 21:19:19 -0700, Justin Mattock <justinmattock@gmail.com> wrote:
> so far I've compiled most of the system
> (glibc,Xserver,etc..)
> and not really anything has crashed and burned
> except for the kernel:
> 
You are using a pre-release compiler. It should be no surprise that it chokes
on the kernel. You should do as the compiler said and report this to the gcc
folks.

- Ben

