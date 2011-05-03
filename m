Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab1ECUUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:20:19 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53669 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab1ECUUR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:20:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pHl1/ydsk9eTtIY9HDKi7c+hgUJnt8HQNFGiGjhFAK+SCLwgRDZYevK3E0lGU7e2Bu
         96qWy79U003kMpqzNerqW1juu9rDYBZi42l/5M5XRpDutv0fFRtNVARNaTeDq+cg+dBw
         KR7iO/OGXzxw2WShS1f9EkSci9ocpuCMIBFKM=
MIME-Version: 1.0
In-Reply-To: <4DC0312A.4040303@lwfinger.net>
References: <776913.88107.qm@web161609.mail.bf1.yahoo.com> <4DC0312A.4040303@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 3 May 2011 22:19:57 +0200
Message-ID: <BANLkTinw+jv8zBi29EKs2K2=tAJMYCEdgQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] rtlwifi: rtl8192se: Merge new driver
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Walter Goldens <goldenstranger@yahoo.com>,
        John W Linville <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, chaoming_li@realsil.com.cn
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 3, 2011 at 6:45 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 05/03/2011 10:59 AM, Walter Goldens wrote:
>>
>>> This set of patches introduces a driver for the RTL8192SE PCI devices.
>>
>> Any estimates on the *SU driver? :)
>
> Now that rtl8192se is submitted, I will start work on the driver for the
> RTL8192DE devices. After that will be the RTL8191SU. It has lower priority
> because r8712u from staging handles those devices. It is not based on
> mac80211, but it works.

Again, may I remind you that the preferred behavior in the Linux world
is release-early, release-often? :-)

>
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
