Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab0HCSuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:50:08 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:58740 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757556Ab0HCSuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:50:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=
	mime-version:date:message-id:subject:from:to:cc:content-type; q=
	dns; s=drama; b=BetRgKAseXuGx4gH04zBw30zIjPfKckUwk1i3bW9frNLTldh
	DFIypsbBFqUJReXj3iYO/iiAyeisPKHaFxrJcviuB1woub6LxZpjccq+zwA5WYm5
	MOOI5ioy9hIav9LhsOGpCfUJvVy+2/Sa+uHfDo3J/QeLN36dYWhT8q+CImI=
MIME-Version: 1.0
Date: Tue, 3 Aug 2010 11:49:59 -0700
Message-ID: <AANLkTikB=3zfMs0fUOysLnN15Lm9PhwTOO=fRR-XXR9e@mail.gmail.com>
Subject: rbd
From: Yehuda Sadeh Weinraub <yehuda@hq.newdream.net>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Sage Weil <sage@newdream.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, Jens,

  We've posted rbd a few times before. Rbd provides a block device
that stripes data over ceph's block layer (rados). Other than a few
trivial bug fixes it hasn't changed much from our last post, and the
latest version can be found on the rbd branch at
git://ceph.newdream.net/git/ceph-client.git.

First, we'd like to know if it's acceptable to include the rbd block
driver as part of the ceph module, or whether we need to restructure
ceph so that it'd be possible to add rbd as a separate module.

Second, is there any specific person's ACK or review we need in order
to send this upstream with the rest of the ceph 2.6.36 queue?

Thanks,
Yehuda
