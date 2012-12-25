Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab2LYNjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 08:39:23 -0500
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3914 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab2LYNjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 08:39:21 -0500
Date: Tue, 25 Dec 2012 14:38:41 +0100
Message-Id: <201212251338.qBPDcfSg026316@xs8.xs4all.nl>
From: "Miquel van Smoorenburg" <mike@van-smoorenburg.nl>
To: bbi5291@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Does init start with any open files?
In-Reply-To: <CAMmfjbPKGD28070A0JvMyL02juYW5tuwNmVwrJ-1gFzkNhCuDQ@mail.gmail.com>
Organization: 
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <xs4all.CAMmfjbPKGD28070A0JvMyL02juYW5tuwNmVwrJ-1gFzkNhCuDQ@mail.gmail.com> you write:
>When the init process is created on system startup, does it have any
>open file descriptors? If so, where do they point?

0, 1 and 2, which are connected to the console. Boot a kernel with
"init=/bin/bash" and see for yourself.

Mike.
