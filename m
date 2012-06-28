Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab2F1RJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 13:09:50 -0400
Received: from smtp.witbe.net ([81.88.96.48]:34944 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549Ab2F1RJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 13:09:49 -0400
Date: Thu, 28 Jun 2012 19:09:43 +0200
From: Paul Rolland <rol@as2917.net>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: 3.5.0-rc3 - Issue with CFQ and cgroup
Message-ID: <20120628190943.15f65dcd@tux.DEF.witbe.net>
In-Reply-To: <20120628160855.GB22641@google.com>
References: <20120627195808.31714295@tux.DEF.witbe.net>
	<20120627182202.GO15811@google.com>
	<20120628095103.3c6c0a1e@tux.DEF.witbe.net>
	<20120628155754.GA22641@google.com>
	<20120628180443.01242645@tux.DEF.witbe.net>
	<20120628160855.GB22641@google.com>
Organization: AS2917.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.7; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, 28 Jun 2012 09:08:55 -0700
Tejun Heo <tj@kernel.org> wrote:

> You cloned block tree into for-linus directory and then implicitly
> used the master branch of the block tree, which is mainline.  What
> should have been done are...
> 
> * git clone git://git.kernel....block.git block
> * cd block
> * git checkout for-linus

OK, just boot that version and it's fixing the issue (BTW, your patch is
nicer than mine ;)

Thanks,
Paul
