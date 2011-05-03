Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384Ab1ECIFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 04:05:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46845 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1ECIFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 04:05:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=MrZ7ANCnnUs0a6k1bfOQh3XudBq+jN6TbG/9ja3GmIIQtJf4zaqXeqln+FG4yDNoVk
         0XeDGNEUCW5iTxCny4ATVSaCskRGVDaLgBA5fDcq/UbmJ93wn4sZ6FhFnt5qb0j5dhRx
         QSPYrEr3t/O4Unb/enfc0nSUwz5n7PCZpbABk=
MIME-Version: 1.0
Date: Tue, 3 May 2011 13:35:06 +0530
Message-ID: <BANLkTi=7N=vrj1S8-=wvVieTss-SnBfXew@mail.gmail.com>
Subject: Vesafb - need double framebuffer
From: suman <vijayendra.suman@gmail.com>
To: kraxel@goldbach.in-berlin.de, linux-kernel@vger.kernel.org,
        sankar.r@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr Kraxel,

I want to inquire about the vesafb driver, which provides only one
device node that is /dev/fb0.
I am trying to develop a qt UI for this i need to have another
framebuffer /dev/fb1, how can i add one more fb, should i use
framebuffer_alloc function to allocate a new frame buffer. Do you have
any patch for providing two frame buffers in case of vesafb driver. I
have tried on net and i failed to find any suitable patch for the
same.

-- 
Rgds
Vijayendra Suman
