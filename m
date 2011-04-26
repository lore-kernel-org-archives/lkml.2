Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab1DZNUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 09:20:53 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:32971 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755527Ab1DZNUw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 09:20:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kjs1mOa8CR7t2ul3Gi+3bPCoNawZgx5On71jWvVx36KNz9CchbwNscHQRG/NcUS2/d
         x9FUZjYD/bustTTx1pDvFXXqKmbJkslw2jIWVDF3SXHC/gHR0TOxzw4F3WQ2xGZRSRZO
         uMAuitNUPsvkdYlDq6AcCipECf+TwK1NknXvA=
MIME-Version: 1.0
In-Reply-To: <20110426104635.GA13252@opensource.wolfsonmicro.com>
References: <cover.1303408522.git.bengardiner@nanometrics.ca>
	<e6aa9fd05c44088ab8446f1c60d2056f92929483.1303408522.git.bengardiner@nanometrics.ca>
	<20110426104635.GA13252@opensource.wolfsonmicro.com>
Date: Tue, 26 Apr 2011 09:20:50 -0400
Message-ID: <BANLkTimPzok1VCefK1GtNaLM+Tg0nrR9=Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] davinci-mcasp: correct tdm_slots limit
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        James Nuss <jamesnuss@nanometrics.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 6:46 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Apr 21, 2011 at 02:19:01PM -0400, Ben Gardiner wrote:
>> The current check for the number of tdm-slots specified by platform data is
>> always true (x >= 2 || x <= 32); therefore the else branch that warns of an
>> incorrect number of slots can never be taken.
>
> Applied all of these.  Please always try to ensure that your commit logs
> are consistent with the rest of the subsystem so they don't need to be
> rewritten.

Thanks, Mark, for taking the patches anyways (and Liam for the Ack's)
-- Sorry I forgot the 'ASoC' tag (I noticed this patch was committed
as 049cfaa ASoC: davinci-mcasp: correct tdm_slots limit).

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
