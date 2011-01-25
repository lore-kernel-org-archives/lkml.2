Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1AYCPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 21:15:16 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34356 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab1AYCPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 21:15:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=JUnxn7JaztdB9tKYuLvQSoXKDoyvRSEiENjE8MYX4wF4QbcDHm5eKl9+trSgjl5BS/
         hZdiDGNq4YowHIeoCM1vcDrgCY9F/zdEaLb5qKpsqEvYk2vk/fPDQCOuAMMcxd5PEaB3
         s87Lnp8aj+FpYYx2dw+FczxZFBSTE14VgUheY=
MIME-Version: 1.0
Date: Tue, 25 Jan 2011 10:15:14 +0800
Message-ID: <AANLkTi=eCOiP7MrUSG4WRMN0kj_+ZWvZ=z7VYDfkshU_@mail.gmail.com>
Subject: questions about arm trustzone
From: sen wang <wangchendu@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we need to build a little os in the secure mode,and run linux in the
normal world.but, can I use gcc to compile the special instructions like 'smc'.
which gcc version can work? and where can i find the example code
switching between the secure and normal worlds?
