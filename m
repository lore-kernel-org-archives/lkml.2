Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab0IBUw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:52:59 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38886 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab0IBUw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:52:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dK+349vRM7s143UgGrdtEfzwa9QBu6ytuE89LGLcSUgWuFQvrP6+2ozt5CM0UP9Tbk
         cbpSkV+ueoovA8RetXnX67nLgqeTBCUUYimuii7b+1+XJNS5Ocd8aiYvhceYNJUh8Pi7
         RGzC+UEKzGEY4RJestPuo6PdxR2GLfgRyaIZY=
MIME-Version: 1.0
In-Reply-To: <201009021633.22869.stephan.diestelhorst@amd.com>
References: <201007091750.05020.stephan.diestelhorst@amd.com>
	<4C7F6931.4050707@gmail.com>
	<4C7F7649.3010409@gmail.com>
	<201009021633.22869.stephan.diestelhorst@amd.com>
Date: Thu, 2 Sep 2010 22:52:56 +0200
Message-ID: <AANLkTi==kpbcJQ9E_MMfs9Ohu_O4vNsf8T7NK1z+iAwn@mail.gmail.com>
Subject: Re: [PATCH] libata: skip EH autopsy and recovery during suspend
From: Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
To: Tejun Heo <htejun@gmail.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 4:33 PM, Stephan Diestelhorst
<stephan.diestelhorst@amd.com> wrote:
> On Thursday 02 September 2010, 12:02:49 Tejun Heo wrote:
>> For some mysterious reason, certain hardware reacts badly to usual EH
>> actions while the system is going for suspend.  As the devices won't
>> be needed until the system is resumed, ask EH to skip usual autopsy
>> and recovery and proceed directly to suspend.
>
> Thanks Tejun for this patch. Will test in a second!

Applied, compiled and worked for the 5 iterations I managed to test it.
Much better than your previous patch, thanks a lot! I'd give it some more spins
tomorrow, though.


Thanks,
  Stephan
