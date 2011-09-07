Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab1IGWwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 18:52:40 -0400
Received: from mail-vw0-f43.google.com ([209.85.212.43]:57775 "EHLO
	mail-vw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756985Ab1IGWwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 18:52:39 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Sep 2011 18:52:39 EDT
MIME-Version: 1.0
Date: Wed, 7 Sep 2011 17:45:39 -0500
Message-ID: <CAG11QsKymopV9bcUFBgDCEYdJ3Wwa0gCAov3gkXqYFXL22OxCw@mail.gmail.com>
Subject: Epoll as kernel module?
From: Someone Something <fordhaivat@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are lots of old deployments that don't have epoll, and its a
real pain writing code for these systems. Is it a good idea to write a
module for epoll since it is basically poll running in the kernel
space?I think it would be an excellent idea, and if there is approval
in the community, I would be glad to start working on it, I just
wanted your opinions before I do that.
