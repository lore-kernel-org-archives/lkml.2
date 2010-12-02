Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab0LBBgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 20:36:37 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:54270 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756408Ab0LBBgf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 20:36:35 -0500
MIME-Version: 1.0
In-Reply-To: <1291231567-notmuch-felipe.contreras@nokia.com>
References: <1288033806-1496-1-git-send-email-x0095840@ti.com>
	<20101129.104729.97149649.Hiroshi.DOYU@nokia.com>
	<1291231567-notmuch-felipe.contreras@nokia.com>
Date: Wed, 1 Dec 2010 19:36:34 -0600
Message-ID: <AANLkTimQcXrgxGjZonSUSkXqoHfAVVhXuHnGKBkMKc9X@mail.gmail.com>
Subject: Re: [PATCHv5 0/4] omap: iovmm - fixes for iovmm module
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Felipe Contreras <felipe.contreras@nokia.com>
Cc: Hiroshi.DOYU@nokia.com, x0095840@ti.com, h-kanigeri2@ti.com,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 1, 2010 at 1:27 PM, Felipe Contreras
<felipe.contreras@nokia.com> wrote:
> Hiroshi.DOYU@nokia.com wrote:
>> From: ext Fernando Guzman Lugo <x0095840@ti.com>
>> Subject: [PATCHv5 0/4] omap: iovmm - fixes for iovmm module
>> Date: Mon, 25 Oct 2010 21:10:02 +0200
>>
>> > Version 5:
>> > * Changes in "iommu: create new api to set valid da range"
>> >   - Change range variables to platform data structure.
>>
>> Acked-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
>
> Does that means you are going to send a pull request with these for .38?
>
> Fernando, is there a branch where you have all the changes needed in
> tidspbridge?

No, I dont have that branch.

>
> I guess the only patch missing would be the one for linux-arm.

Yes, after merging them, the only missing is the SG chain patch.

Regards,
Fernando.

>
> Cheers.
>
> --
> Felipe Contreras
>
