Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab0DNKY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 06:24:56 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64616 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab0DNKYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:24:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ZFxgqH2MPA1noyDTGO4UDF40Fje3R+EjahHkZ+m1rMpt/rW7X83mtYREOIBtH+YJ2A
         VzcSpyxbep5t9GYfSRrcb+qJcwUrXGNgnpZl0vUF9dK61nObqsyE5OXR9f0Oic3U1TFR
         L9uDjpHfeQqNFKtsUobRQfir6Jq6k2n0usyp0=
MIME-Version: 1.0
Date: Wed, 14 Apr 2010 15:54:54 +0530
Message-ID: <u2q887f81cc1004140324z1f2ec9f4ref9f6cdc1b6c68da@mail.gmail.com>
Subject: arch/x86/boot/header.S code
From: anil kumar <m.anilkumar80@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I am trying to understand assembly code written in arch/x86/boot/header.S code.
I am not able to grab meaning of following line:
 .section ".bstext", "ax"

Can you tell meaning of this line ?

Thanks,
Anil

PS: It would be great help if someone can point any link which explain
code mentioned in this file.
I am not able to locate any good link using google search engine.
