Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854Ab2FOXiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 19:38:16 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52696 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549Ab2FOXiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 19:38:14 -0400
MIME-Version: 1.0
Date: Fri, 15 Jun 2012 18:38:13 -0500
Message-ID: <CAB7xdikq8CiRp9cMEGCQMA10qEKjCw=RPkOJ4N0QcXcKroaV2Q@mail.gmail.com>
Subject: write protect the guest memory page from guest access
From: sheng qiu <herbert1984106@gmail.com>
To: kvm <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

i want to set write protect (if guest try to write access, cause
exception) for a guest memory page. Assuming i know the gva of the
page, how do i achieve this? Is there any existing KVM function that
can help do it?

Thanks,
Sheng
