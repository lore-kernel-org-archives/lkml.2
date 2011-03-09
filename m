Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab1CIABU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:01:20 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:48683 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab1CIABS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:01:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=fUyLDV/8aousNNlnG6E24vLwol1JX5fTxY1//zzel+LfYHSgJZwG8Ix1nDzhOEx19I
         6IwyvntubDgRWjCPgG+rbfcaDLQ5lgUB7hX38f2qLiYycIaO52SrjSMUCMjyVj7atKWg
         mLAt+I1Y7byaega6jc04kO/EOkiu1sW8DKsj4=
MIME-Version: 1.0
In-Reply-To: <20110308210227.GA12804@redhat.com>
References: <4D75D338.9070801@samsung.com>
	<20110308210227.GA12804@redhat.com>
Date: Wed, 9 Mar 2011 09:01:17 +0900
Message-ID: <AANLkTikfQGZwXj52ew1Zh9gc+YeLxevivaBocx8_uOz-@mail.gmail.com>
Subject: Re: [PATCH v3] misc: adds support the FSA9480 USB Switch
From: Minkyu Kang <promsoft@gmail.com>
To: Dave Jones <davej@redhat.com>, Minkyu Kang <mk7.kang@samsung.com>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
        kyungmin.park@samsung.com, Ben Dooks <ben-i2c@fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Dave Jones,

On 9 March 2011 06:02, Dave Jones <davej@redhat.com> wrote:
> On Tue, Mar 08, 2011 at 03:56:56PM +0900, Minkyu Kang wrote:
>
>  > +static DEVICE_ATTR(switch, S_IRUGO | S_IWUGO,
>  > +            fsa9480_show_manualsw, fsa9480_set_manualsw);
>
> This probably shouldn't be world writable if it's writing to hardware.
>

It can be used in user space.

Thanks
Minkyu Kang
-- 
from. prom.
www.promsoft.net
