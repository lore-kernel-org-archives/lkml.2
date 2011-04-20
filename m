Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab1DTRZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 13:25:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62489 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1DTRZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 13:25:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tRgZnQpOyDwvVwTvEpbP+udoGLedS+FNSUA9wgDVoM6VN0NHJ0F1hWm14AfK28lmmf
         OQsgdChy3UKB+ImQV8mE7rZDwLDlCoPiuf8LCRKLXroJsl5e/ddKBq4+RMrWUJS/Yy0x
         i1eiof6PuxAJCUF21Ngo6krcArBOSXpGw72Q8=
Date: Wed, 20 Apr 2011 21:25:02 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Benson Leung <bleung@chromium.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, rklein@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] gpio-charger: Add gpio_charger_resume
Message-ID: <20110420172502.GB13169@oksana.dev.rtsoft.ru>
References: <1301796792-28806-1-git-send-email-bleung@chromium.org>
 <1302134120-29589-1-git-send-email-bleung@chromium.org>
 <4D9D0227.3000807@metafoo.de>
 <BANLkTinEgCeXtv0kW7XTu142LjFucnKwHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BANLkTinEgCeXtv0kW7XTu142LjFucnKwHA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 09:19:42PM -0700, Benson Leung wrote:
> Thanks Lars.
> 
> Hi Anton,
> 
> Can this patch be applied?

Applied, thanks!

> On Wed, Apr 6, 2011 at 5:15 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> > On 04/07/2011 01:55 AM, Benson Leung wrote:
> >> Gpio charger should notify if the gpio state had changed
> >> during suspend. This will send a CHANGED event each time
> >> the system resumes, ensuring a plug/unplug of the charger
> >> is not missed.
> >>
> >> Signed-off-by: Benson Leung <bleung@chromium.org>
> > Acked-By: Lars-Peter Clausen <lars@metafoo.de>

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
