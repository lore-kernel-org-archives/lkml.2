Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab1C3OI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:08:58 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45236 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab1C3OI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:08:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=Rp6r64KUhDlu5Oq9cpxMLuiFncJVBUBvz/iaS48YUo2H5TVzPCCxeXaON8tivrLW/5
         Yq5qbYn69lKKzsAopL8ABC3bgBZJyzE84DqJ+ZgMfVIq3axap+GaF9pQkiswXIzXawGv
         rjrOJ94Ez6CegfKfF46PVsMaUFe3C0IpuDQlc=
Date: Wed, 30 Mar 2011 22:08:46 +0800
From: "wanlong.gao" <wanlong.gao@gmail.com>
To: "richardcochran" <richardcochran@gmail.com>
Cc: "john.stultz" <john.stultz@linaro.org>, "tglx" <tglx@linutronix.de>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: re:[PATCH] posix clocks: replace mutex with reader/writer semaphore 
Message-ID: <201103302208400936168@gmail.com>
X-mailer: Foxmail 6, 15, 201, 23 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Oh, I see a good work .

