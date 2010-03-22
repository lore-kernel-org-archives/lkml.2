Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab0CVEQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 00:16:15 -0400
Received: from mx.4pi.com ([24.172.19.59]:49629 "EHLO mx.4pi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab0CVEQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 00:16:14 -0400
X-Greylist: delayed 1364 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Mar 2010 00:16:14 EDT
Mime-Version: 1.0
Message-Id: <p06240805c7cc98bdf217@[192.168.9.6]>
In-Reply-To: <c384c5ea1003211403t494bd794hece06d8b8cfcb54@mail.gmail.com>
References: <c384c5ea1003211403t494bd794hece06d8b8cfcb54@mail.gmail.com>
Date: Sun, 21 Mar 2010 23:53:15 -0400
To: Leon Woestenberg <leon.woestenberg@gmail.com>
From: "Scott D. Davilla" <davilla@4pi.com>
Subject: Re: CrystalHD driver safe on big endian systems?
Cc: jarod@wilsonet.com, "Naren (Narendra) Sankar" <nsankar@broadcom.com>,
       "hancockrwd@gmail.com" <hancockrwd@gmail.com>,
       "jarod@redhat.com" <jarod@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "abraham.manu@gmail.com" <abraham.manu@gmail.com>
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>has the CrystalHD driver/library been tested on big endian systems?
>
>The (staging GIT tree) driver sources seem to use bitfields in C, is
>this safe under different endianess?
>
>I'm currently testing two BCM70012 modules on a big-endian PowerPC
>system and it fails changing the clock PLL to 175 MHz. This could be a
>pair of defective modules, or the wrong bits being modified.
>Unfortunately, I do not have a little endian system with mini-PCIe
>available to do a A-B check.

Not sure if anyone has done work testing under big endian platforms. 
 From what I've seen in code, it looks definite little endian based 
and would need a look over regarding byte swap.

Scott
