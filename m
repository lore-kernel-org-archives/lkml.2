Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934659Ab0GOVsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 17:48:51 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59565 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934092Ab0GOVsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 17:48:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=JBk9+dWKeM9Gl4UcRvI6XUL+dmUNw9cfymz9vel4rFJyg6KhY1Ah2YRkFnp7CauA7V
         RLtKwZ/aSrGeD6syG/7kTpXjfKxDXFH+vcPBRodQFj5ZDON7w7iQOtKVupm1o1RQs7Uy
         uc6DHUoyqOfQ3klVIBZrP0SUEdeMlVMDFFIbs=
MIME-Version: 1.0
Date: Thu, 15 Jul 2010 16:48:48 -0500
Message-ID: <AANLkTilDmFF4IN1Glo_Bv_-eBX1jcdi7JDToeIbvToC8@mail.gmail.com>
Subject: anonymous mmap() and random heap allocation
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems mmap() can not do random allocation for malloc()/heap on
Linux, anyone used pax's 'mmap randonness' option for that? what's the
price for that?

I want to port openbsd's malloc() to linux to avoid heap
crashes(overrun/underrun), openbsd's malloc() can do random allocation
for security reasons, meanwhile it helps to avoid some
overrun/underrun crashes with no extra cost, the latter is what I'm
looking for.

thanks,
xianghua
