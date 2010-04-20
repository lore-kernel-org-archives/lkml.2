Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0DTQWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 12:22:45 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:58757 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab0DTQWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 12:22:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=maIXFhY9i3VWgfoMKK9d2ZIvPqGR9Vvaw7pkiVYZq4ZavKIhAPJzuePAZUb6M2C+6A
         yPH2pRRunCke6QAUGcaOy1/aQCslaWa5HuV8eyHkbBeJAq2kcoynynUSyAlYS+PoH8z0
         eSPYcQCZbg5ZYJxjO5aKi/KTz1m+E+M2AKReg=
MIME-Version: 1.0
Date: Tue, 20 Apr 2010 21:52:43 +0530
Message-ID: <k2vcfeab66d1004200922v4c2f062dqfbd5d31f5ad19f5a@mail.gmail.com>
Subject: rx interrupt in userspace
From: ratheesh k <ratheesh.ksz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,

 When flooding of network  packets happens on network card  ,  my
linux embedded box becomes unrepsonsive because softirq_rx eats up
hell a lot of CPU . I want  top half of tx interrupt to be in User
space . I want to implement some alogoritm in userspace  to drop
packets on high flooding and to keep other processes's some cycles .

Could you guide me a little on this , any online turorials or articles
or books , i can refer ?
Any similar implementation like this ?


Thanks,
Ratheesh.
