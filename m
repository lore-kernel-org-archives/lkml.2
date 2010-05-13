Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab0EMIMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 04:12:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:25669 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab0EMIMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 04:12:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=x2CiO0ghml9q0v/BgyP/e2k/JOdt2b5sFjeXaHxgT/2AKBfY1vHgXBAqkWycZstoQv
         NmHwjZ72HEkrdLvPdD82IYJYzYZsTgc89d6pBiVEnp+yF7vHYN/bJe29zhdonSPhaw92
         8sK9KPXM+Ckzw6H8J+ZnLcxegoCygHKobb7V0=
Message-ID: <4BEBB470.9040501@gmail.com>
Date: Thu, 13 May 2010 10:12:32 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.5pre) Gecko/20100430 SUSE/3.1b2-7.1 Thunderbird/3.1b2
MIME-Version: 1.0
To: ratheesh k <ratheesh.ksz@gmail.com>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Differnce between kthread and worqueue ?
References: <AANLkTik5vq9XHP4eCYw2J4eZVf3pwJZGP_9C4T93otAs@mail.gmail.com> <4BEBB413.9010404@gmail.com>
In-Reply-To: <4BEBB413.9010404@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 10:10 AM, Jiri Slaby wrote:
> On 05/13/2010 09:25 AM, ratheesh k wrote:
>> What is the real difference between these ? . I know that workqueue
>> run on process context and can sleep ..what about kthread ?
> 
> Well, workqueue runs in a kthread called name_of_your_workqueue/cpu
> ("/cpu" is omitted when singlethread wq). 

(And when you use just schedule_work and create no workqueue for
yourself, it's "events/cpu" kthread.)

-- 
js
