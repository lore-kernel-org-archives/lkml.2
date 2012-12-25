Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab2LYIHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 03:07:34 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:49469 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab2LYIHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 03:07:31 -0500
MIME-Version: 1.0
Date: Tue, 25 Dec 2012 02:38:09 -0500
Message-ID: <CAMmfjbPKGD28070A0JvMyL02juYW5tuwNmVwrJ-1gFzkNhCuDQ@mail.gmail.com>
Subject: Does init start with any open files?
From: bbi5291 <bbi5291@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the init process is created on system startup, does it have any
open file descriptors? If so, where do they point?
________________________________
Brian Bi
