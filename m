Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab1LBRd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 12:33:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170Ab1LBRd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 12:33:56 -0500
Message-ID: <4ED90BFD.3040805@redhat.com>
Date: Fri, 02 Dec 2011 15:33:49 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: HoP <jpetrous@gmail.com>
CC: Andreas Oberritter <obi@linuxtv.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED6C5B8.8040803@linuxtv.org> <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <4ED7BBA3.5020002@redhat.com> <CAJbz7-1_Nb8d427bOMzCDbRcvwQ3QjD=2KhdPQS_h_jaYY5J3w@mail.gmail.com> <4ED7E5D7.8070909@redhat.com> <4ED805CB.5020302@linuxtv.org> <4ED8B327.9090505@redhat.com> <CAJbz7-2EVgwPY0wkqPVCoOyH2gM_7pf0DzP-Lf4Y65uZpci9GQ@mail.gmail.com>
In-Reply-To: <CAJbz7-2EVgwPY0wkqPVCoOyH2gM_7pf0DzP-Lf4Y65uZpci9GQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02-12-2011 09:57, HoP wrote:

> If you want to disscuss,

No, I don't want. There are architectural issues on your solution. As I said,
from the Kernel POV, just the network drivers is enough to run *any* client-server
solution on any OS that uses the TCP/IP stack. All streaming applications (DVB
or not) have their solution without requiring any virtual driver, using the TCP/IP
stack. You still think that your solution is technically better than theirs.
So, we agree do disagree on that matter.

 From my side, I won't merge it due to the already explained reasons.
Mauro.

