Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab2FRJOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:14:12 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48848 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836Ab2FRJOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:14:11 -0400
MIME-Version: 1.0
In-Reply-To: <1340002390-3950-1-git-send-email-asias@redhat.com>
References: <1340002390-3950-1-git-send-email-asias@redhat.com>
Date: Mon, 18 Jun 2012 10:14:09 +0100
Message-ID: <CAJSP0QXOn-5Krm6hSMmm=zRYkG43k9F4Xe6P+ENMFtgMhTupFA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Improve virtio-blk performance
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Asias He <asias@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 7:53 AM, Asias He <asias@redhat.com> wrote:
> Fio test shows it gives, 28%, 24%, 21%, 16% IOPS boost and 32%, 17%, 21%, 16%
> latency improvement for sequential read/write, random read/write respectively.

Sounds great.  What storage configuration did you use (single spinning
disk, SSD, storage array) and are these numbers for parallel I/O or
sequential I/O?

What changed since Minchan worked on this?  I remember he wasn't
satisfied that this was a clear win.  Your numbers are strong so
either you fixed something important or you are looking at different
benchmark configurations.

Stefan
