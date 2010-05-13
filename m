Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab0EMH0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:26:00 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52682 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab0EMHZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:25:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=FMCNREx8hswwkoreXkiRiBSNnRFafqblQmkpcWlrFJ/Vm5ptSzMXtgdjP2iKAb1P7B
         YkjMImWyYPtIU5rDkF4Pl8q8ynLNOTORTcJKtlzO5mf/eXiZIxLAUz9RoI8hgjPEEPFR
         HO1M/g4wy2GwRNnvX0qp1Zr2LijO6JqbFEgIs=
MIME-Version: 1.0
Date: Thu, 13 May 2010 12:55:56 +0530
Message-ID: <AANLkTik5vq9XHP4eCYw2J4eZVf3pwJZGP_9C4T93otAs@mail.gmail.com>
Subject: Differnce between kthread and worqueue ?
From: ratheesh k <ratheesh.ksz@gmail.com>
To: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is the real difference between these ? . I know that workqueue
run on process context and can sleep ..what about kthread ?

Thanks.
Ratheesh
