Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab0JEBjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 21:39:18 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55351 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab0JEBjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 21:39:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=nY5dUjNytIq0CaN/mXDaS9uHmjKsVvoJqRlOlciwvTrfFpu4UGMBvsGwy796mZ1sjR
         CZ5WFDMBuRWoJpPzL9xd6Q0a6gTSseNqyKruhs/CigNGSAcLbuIbQkKgA4EVnHaHnW8B
         R+USwJ//8ap5P8fDIEH1WvsvQUBP1i36nvOoI=
MIME-Version: 1.0
Date: Mon, 4 Oct 2010 21:39:16 -0400
X-Google-Sender-Auth: vJfBYoRTprwFyCbo7F9gVPZjmMQ
Message-ID: <AANLkTimKpVR5UVYLetwt=S4PSkMEJTBpUk7Q-o=ha_ds@mail.gmail.com>
Subject: Detecting runnable process?
From: Philip Wernersbach <philip.wernersbach@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm writing some kernel code that given a task's task_struct must
decide if it is runnable, and hasn't crashed or exited. So far here's
what I've come up with:

struct task_struct *my_task;
... snip ...
if(likely(my_task != NULL && pid_alive(my_task) == true)) { return my_task; }

Is this correct?

-Phil
