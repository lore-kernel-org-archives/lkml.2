Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab2HSIMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 04:12:48 -0400
Received: from mail.nonattached.net ([193.160.39.60]:54765 "EHLO
	mail.nonattached.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2HSIMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 04:12:20 -0400
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
From: Dan Luedtke <mail@danrl.de>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com>
References: <1345333117-2826-1-git-send-email-mail@danrl.de>
	 <CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Aug 2012 12:12:15 +0200
Message-ID: <1345371135.4441.2.camel@tunafish>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resent)
On Sun, 2012-08-19 at 00:16 +0200, richard -rw- weinberger wrote:
> What are the use cases of this filesystem?
> It looks very minimal without much features.
That's the feature, actually. Think of the Arduino platform or other embedded devices (TV, Car Entertainment) that just want to read/play files. You're right, no big features, but that's by design.

Dan
-- 
Sent from my mobile phone. Please excuse my brevity.


