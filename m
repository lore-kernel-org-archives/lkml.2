Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab1C3FIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 01:08:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57934 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab1C3FIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 01:08:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=Rvq3op9dgAspq0/QYTBKV3kG/Yr3vnsT4YU+Eo1h1RxMiFUSx/Aqf0KWxgRaC9+Y4U
         xgpcAfYkZDnfiRwgyb/8SBApNfb1TW0lxSQbpb4500oL50mXRrTgtRya79qTL9GkVJr5
         7l7oLkCa7uQ6vALrtjsGmn+wiGxInnhd2bRGo=
MIME-Version: 1.0
From: Keval Vora <kevalvora@gmail.com>
Date: Wed, 30 Mar 2011 10:38:33 +0530
Message-ID: <AANLkTi=9kaSJ6hOa6rB7QScSa-aStf45cHA_HNASicUP@mail.gmail.com>
Subject: Compiling kernel 2.6.12
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I was trying to compile the kernel 2.6.12. The command "make O=/build
menuconfig" executed successfully. However I am getting the following
error on executing "make O=/build":

operand type mismatch for `mov'

I am a student and I particularly wanted to compile this version
because there are few patches coded for this version I need to study
them and may be extend them. Can anyone please help me with this one?

- Keval
