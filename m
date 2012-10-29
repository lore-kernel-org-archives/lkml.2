Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921Ab2J2NkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:40:01 -0400
Received: from void.printf.net ([89.145.121.20]:60460 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105Ab2J2Nj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:39:59 -0400
From: Chris Ball <cjb@laptop.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Will Newton <will.newton@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dw_mmc: fix multiple drv_data NULL dereferences
References: <1350376988-27477-1-git-send-email-james.hogan@imgtec.com>
	<507E129D.8000401@samsung.com>
	<CAFbHwiSUoP_W=CK1hF+CYjxrJ1P6BR9=y_grEogmo5br6R_zuw@mail.gmail.com>
	<508E4DB6.20504@imgtec.com>
Date: Mon, 29 Oct 2012 09:39:48 -0400
In-Reply-To: <508E4DB6.20504@imgtec.com> (James Hogan's message of "Mon, 29
	Oct 2012 09:34:46 +0000")
Message-ID: <87a9v5xuqj.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Oct 29 2012, James Hogan wrote:
> On 17/10/12 10:11, Will Newton wrote:
>> Looks good to me too.
>> 
>> Acked-by: Will Newton <will.newton@imgtec.com>
>> 
>> On Wed, Oct 17, 2012 at 3:06 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>>> Looks good to me.
>>>
>>> Acked-by: Jaehoon Chung <jh80.chung@samsung.com>
>
> Thanks for the acks Thomas, Seungwon, Jaehoon and Will.
>
> Chris: Any chance of queueing this patch for v3.7?

Yes, certainly -- pushed to mmc-next for 3.7, thanks.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
