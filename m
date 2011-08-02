Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab1HBAPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 20:15:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45414 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1HBAPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 20:15:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAPweEDyUJZ8ggm0zhMquKNM6Kd-ejjUXrCMR3TnJngukSHAFkw@mail.gmail.com>
References: <CAPweEDyUJZ8ggm0zhMquKNM6Kd-ejjUXrCMR3TnJngukSHAFkw@mail.gmail.com>
Date: Tue, 2 Aug 2011 01:15:34 +0100
Message-ID: <CAPweEDyW9aTKJzUrVdANjK5mG0DW9+R4GRCG5_oaaX8RTEezwg@mail.gmail.com>
Subject: Re: corrupted ext4 1000gb filesystem (2.6.32, debian stable)
From: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ok, um... i have a bit more information about this situation, to
report.  two consecutive runs of fsck.ext4, and the filesystem still
reports errors after the first run "corrected" all errors. i'd say
that was a bit serious.

l.
