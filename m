Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab1AaIqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 03:46:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45910 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab1AaIqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 03:46:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=nujbba7Opu1tF5eQTAZyuSFiJVAsmXYj/HgeHMvtx8kdCEFQ8y7RSC4B04+QtzBzmJ
         7onbWnPf//6BNKbtjQGTMNd8eY960OSR2sdQXMYpDlZR0/KX0QRMtV6B2Z50PL/7gqut
         ftGVkKe4L23aXaIZM1rdU4cQus6yptapGjU94=
MIME-Version: 1.0
From: Amirali Shambayati <amirali.shambayati@gmail.com>
Date: Mon, 31 Jan 2011 12:15:59 +0330
Message-ID: <AANLkTinDHW9BOFVi9Kux3p_swX-ZtzsravAgXQ2KVooU@mail.gmail.com>
Subject: kernel compilation error
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have problem with compiling kernel. I receive this error during
compilation process:
/include/trace/events/kmem.h:45: undefined reference to `.L1747'
I googled it but I didn't find any useful tip.

Anybody's help is appreciated.

-- 
Amirali Shambayati
Bachelor Student
Computer Engineering Department
Sharif University of Technology
Tehran, Iran
