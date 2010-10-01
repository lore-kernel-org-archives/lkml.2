Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab0JAS1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 14:27:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57970 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab0JAS1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 14:27:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=g7HSwzqnPpduoMaLZawD0ovK2bAbMb3Br7tKMToCRa5rWymvkWVHkljk+3QtuzwmbC
         rMzZkNClMVY/JGNb2vR/BIjajdApLFrdYcLHE6ihSzjCGYdSDeCqxeLbyQOSfrScj80a
         QDJxOn9mcDRyB4RnenRY3ugbMFj0DalSG08kI=
MIME-Version: 1.0
Date: Fri, 1 Oct 2010 15:27:04 -0300
Message-ID: <AANLkTik-RXPfDK12m5OFmLf=gVL1x-h-aDcKX2nz6O3P@mail.gmail.com>
Subject: Information From Buffers
From: Artur Baruchi <mail.baruchi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys.

I would like to get more information about how cache/buffers are being
used by kernel. Is there a way to walk through the buffer_head list
and get these details ?

Thanks in advance.

Artur Baruchi
