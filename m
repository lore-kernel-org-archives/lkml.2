Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab0E1MHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 08:07:25 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:51801 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab0E1MHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 08:07:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=NZJnkLzHNwqN6+PrMuBl9/dTtzwbcVwqVcexfPj1APL1y/gNG70ocldeHAU+wE3CCT
         boTD0xB781HuyJioZTxT0/bYnw8cG8oWJLddzHxE+UCzGMI15m93axapEQh87SFF+vWa
         6Qu4Pl7tzsjUzUcUcG0NeJDg1xhmNyirqG3GU=
MIME-Version: 1.0
Date: Fri, 28 May 2010 15:07:21 +0300
Message-ID: <AANLkTikkju0MNjQwDs-n9EszNTyIP2uE7kcepjVhVBmQ@mail.gmail.com>
Subject: sys_geteuid() quesion
From: Rumen Bogdanovski <rbogdanovski@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I have a simple question:
I need to make a kernel module for a specific character device.
But I need to know which uid is reading and writing because the
data written and data read should be user specific. So will
sys_geteuid() do the job for me. Or simply how can I a
module know who is calling its read or write?

Thank you in advance.

Rumen
