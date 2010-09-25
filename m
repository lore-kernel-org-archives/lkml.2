Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0IYSi7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 14:38:59 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57633 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab0IYSi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 14:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Hbb3oa48dWM+wQnvgW2CEnMxpQwGYVADMQVyuEeMTJuCpi+IX6iJzBRB0NaWBjrnQ+
         aP1UCrCBzVH6DPinOq4xln3yiES9/4CJD4J9xOl1Sd3r3TJfhEIDk4TL4THepb6NBvhc
         DCueLLMv96ZKTf+k2TGiH5N+pPis2QCYoSe7k=
MIME-Version: 1.0
Date: Sat, 25 Sep 2010 14:38:57 -0400
Message-ID: <AANLkTinRwSXGLAccTv+J46d8+F56sHC=Mi-VbMrdxxqf@mail.gmail.com>
Subject: [PATCH 00/10] Fixed checkpatch.pl issues
From: T Dent <tdent48227@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
        sandeen@redhat.com, hch@lst.de, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tracey Dent <Tdent48227@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I correct various issues that checkpatch.pl was having for these
files. Everything to whitespace issues to { }-(braces) not necessary.
I tested that it builds and everything is okay.

:)

Tracey
