Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab1K3Vif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 16:38:35 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47277 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab1K3Vie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 16:38:34 -0500
MIME-Version: 1.0
Date: Wed, 30 Nov 2011 22:38:33 +0100
Message-ID: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
Subject: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
From: HoP <jpetrous@gmail.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks.

I need to warn you that my mail is a bit little longer then I would like
to be.But I'm not able to ask my question without some
background information.

On June 19th, I was sending the driver to the Linux-media
mailing list. Original announcement is there:

http://www.spinics.net/lists/linux-media/msg34240.html

One would say that the code describes very well what it does = adds
virtual DVB device. To be more clear on it I have even done some
small picture:

http://www.nessiedvb.org/wiki/doku.php?id=vtuner_bigpicture

I was hoping to get any feedback regarding code implementation.
It was my first code for the kernel and I felt very well that some
part can be done better or even simpler.

What really surprised me badly was that when I read all 54 responses
I have counted only two real technical answers!!! All rest were about
POLITICAL issues - code was NACKed w/o any technical discussion.
Because of fear of possible abusing of driver.

I didn't know that there existed very big movement against such
code in dvb-core subsystem before.

I have one big problem with it. I can even imagine that some "bad guys"
could abuse virtual driver to use it for distribution close-source drivers
in the binary blobs. But is it that - worrying about bad boys abusing -
the sufficient reason for such aggressive NACK which I did? Then would
be better to remove loadable module API fully from kernel. Is it the right way?

Please confirm me that worrying about abusive act is enough to NACK
particular driver. Then I may be definitely understand I'm doing something
wrong and will stay (with such enemy driver) out of tree.

I can't understand that because I see very similar drivers in kernel for ages
(nbd, or even more similar is usbip) and seems they don't hamper to anybody.

I would like to note that I don't want to start any flame-war, so very short
answer would be enough for me.

Regards

Honza

PS: Please be so kind and CC the answer/comment to me, I'm
only on linux-media ML, not on linux-kernel ML. Thanks.

BTW, if accidentally, somebody find it interesting and would like to
help me doing code review, there is the code hosted now:
http://code.google.com/p/vtuner/source/browse?repo=linux-driver
