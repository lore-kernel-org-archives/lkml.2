Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856Ab1JDQmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:42:06 -0400
Received: from void.printf.net ([89.145.121.20]:52940 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522Ab1JDQmE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:42:04 -0400
From: Chris Ball <cjb@laptop.org>
To: NamJae Jeon <linkinjeon@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        awarkentin@vmware.com, adrian.hunter@intel.com,
        linus.walleij@linaro.org, james_p_freyensee@linux.intel.com,
        sebras@gmail.com, Ulf.Hansson@stericsson.com,
        stefan.xk.nilsson@stericsson.com, per.forlin@stericsson.com,
        johan.rudholm@stericsson.com
Subject: Re: [PATCH v9] mmc : general purpose partition support.
References: <1317745057-6328-1-git-send-email-linkinjeon@gmail.com>
	<m2botwloeq.fsf@bob.laptop.org>
	<CAKYAXd_OhouoyExiWJCzkDSTUUB4cXafLjRPbHwMYgQ6dhsr9A@mail.gmail.com>
Date: Tue, 04 Oct 2011 12:41:47 -0400
In-Reply-To: <CAKYAXd_OhouoyExiWJCzkDSTUUB4cXafLjRPbHwMYgQ6dhsr9A@mail.gmail.com>
	(NamJae Jeon's message of "Wed, 5 Oct 2011 01:36:26 +0900")
Message-ID: <m27h4klnec.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 04 2011, NamJae Jeon wrote:
>> Still doesn't apply here.  Are you sure you're on the "mmc-next" branch
>> of the repository?
>
> I receive mmc-next you inform like this.
>
> git clone git://dev.laptop.org/users/cjb/mmc
>
> What I did wrong ?

You need to type "git checkout mmc-next" afterwards to switch to the
mmc-next branch.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
