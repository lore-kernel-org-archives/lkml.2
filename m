Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145Ab1FWJ0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 05:26:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57031 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab1FWJ0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 05:26:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AiFOMwJOBdXwSdTWIbAHS0eDbUfoHdv73ibriWVUL/83pZlu6BiZu1HjwRVp5S55Hv
         cyjUl3cxxbbchnl1wz4yT8JUqw0ExWIj0egn9YSR5MfNOxbaszP+YAJoAoPo2fFNOjha
         n7g6hpCZRqkgAthm2ZTrwRYJqm+HWrN6slyXI=
MIME-Version: 1.0
In-Reply-To: <20110623110810.6aab0072@endymion.delvare>
References: <1308709299-24539-1-git-send-email-bkankur@gmail.com>
	<20110623100616.4573741f@endymion.delvare>
	<BANLkTikLSmXKG67NroavRb+FjzVE5ie21Q@mail.gmail.com>
	<20110623104525.30718cd7@endymion.delvare>
	<BANLkTikYbpeSbt5VHndJnsWXax1MX+Xk-w@mail.gmail.com>
	<20110623110810.6aab0072@endymion.delvare>
Date: Thu, 23 Jun 2011 14:56:07 +0530
Message-ID: <BANLkTinSwotUC7gWvWxAoFJ0_H--5m7J5g@mail.gmail.com>
Subject: Re: [PATCH 1/1] HWMON: TMP102 - Added support for 12 bit data
From: Ankur Patel <bkankur@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 2:38 PM, Jean Delvare <khali@linux-fr.org> wrote:
>
> On Thu, 23 Jun 2011 14:35:31 +0530, Ankur Patel wrote:
> > On Thu, Jun 23, 2011 at 2:15 PM, Jean Delvare <khali@linux-fr.org> wrote:
> >
> > > On Thu, 23 Jun 2011 13:56:53 +0530, Ankur Patel wrote:
> > > > On Thu, Jun 23, 2011 at 1:36 PM, Jean Delvare <khali@linux-fr.org>
> > > wrote:
> > > >
> > > > > On Wed, 22 Jun 2011 07:51:39 +0530, Ankur Patel wrote:
> > > > > > From: Ankur Patel <ankur.patel@quipment.in>
> > > > > >
> > > > > > In the tmp102.ko driver support for 12 bit data is added. Also, the
> > > > > > sysfs names are replaced with the actual chip supported fuctionality
> > > > > > names.
> > > > >
> > > > > Nack. These attribute names are standard, see
> > > > > Documentation/hwmon/sysfs-interface. You don't get to change them.
> > > > >
> > > > >
> > > > > What problem were you trying to solve? libsensors expects the attribute
> > > > > names which are in use today.
> > > > >
> > > > > Agree, But using temp1_max_hyst as an attribute for presenting low
> > > level
> > > > threshold, will it not more feasible to use temp1_low instead?.
> > >
> > > No. This isn't a min temperature limit. Please read the TMP102
> > > datasheet and in particular Figure 10 "Output Transfer Function
> > > Diagrams" and the description of the AL configuration bit.
> > >
> > > Understood. Thank you. I am reverting back the changes for sysfs attribute
> > names in the submitted patch to original. Do you have other Issue apart from
> > that?
>
> I didn't read the patch, only the header. So I don't know yet. Just
> resubmit and wait for review.
>
> --
> Jean Delvare

I forgot to switch from HTML to plain text and it get bounced from
mailing list. I will resubmit patch soon.

Thank you,
Ankur.
