Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab0DNG1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 02:27:08 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:46566 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab0DNG1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 02:27:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=wMIiYt6c1ZAwekn3o1lwpwCG/XlpOlD4PmRes3KandLBo87+UJWqcSy4JG5r54vOHw
         cw6uKRPKhW4Acj+W68zBjLIsUm/tAeXMSUQ6qDXkr6EMSDRFVR9NYGsOGd1gO+p+2aKL
         lNQgKVc9ZUvhls6negASxhkcYLADwcjaML29Y=
MIME-Version: 1.0
Date: Wed, 14 Apr 2010 11:56:58 +0530
Message-ID: <v2mdbb048f61004132326r8ac75382k1e42321ff0ed484a@mail.gmail.com>
Subject: Dmaengine query
From: rd bairva <rbairva@gmail.com>
To: dan.j.williams@intel.com
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

	I am currently writing dmaengine compatible DMA driver for our ARM
based architecture, But I am facing some performance issues doing
that.

1. dmaengine says callback should run in tasklet, and next transfer
cannot be scheduled from the callback.

Due to these restrictions I am getting some performance issue while
playing sound in our architecture.


Can callback call in DMA driver be placed out of spin_lock to submit
new operations from callback? (only in asynchronous case)

is this Ok? please comment.


Thanks and regards,
Ramdayal
