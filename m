Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab0ICJ1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:27:10 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42867 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab0ICJ1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:27:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=f5lhyTzJFgjJ8yCBjdzSjjAKWNU3DS8TYnMEqej01oTeAdIo7TS1GPjbjm9PpnLGm/
         iDB4MM69byW3Qz/vzEknWUy9B8GohOQgB+vchAFAZCyeN/8u3hL/+XhYvKp5XOjez5I8
         56C4l6GXtEyqZ5Rf/uSiPsK2Zbh3rZT2O1iHU=
MIME-Version: 1.0
In-Reply-To: <4C80BC5C.2010804@kernel.org>
References: <1283446829-24050-1-git-send-email-namhyung@gmail.com>
 <4C7FDCE4.1080703@kernel.org> <AANLkTi=Ema3mTkU7J7XKqmntA+VDJizhBuDHHnZtV_9K@mail.gmail.com>
 <87vd6o9fzf.fsf@gmail.com> <4C80BC5C.2010804@kernel.org>
From: Namhyung Kim <namhyung@gmail.com>
Date: Fri, 3 Sep 2010 18:26:47 +0900
Message-ID: <AANLkTikbZUxrb-n3jxTuPJE4ZvTB4dJ0AsP8rzu4d-Ph@mail.gmail.com>
Subject: Re: [PATCH] ida: fix up bitmap size calculation
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 3, 2010 at 18:14, Tejun Heo <tj@kernel.org> wrote:
> I'd prefer something with a bit more brevity.  If this looks good, can
> you please send it to trivial@kernel.org?
>

OK. So can I add 'Acked-by' line for you?

-- 
Regards,
Namhyung Kim
