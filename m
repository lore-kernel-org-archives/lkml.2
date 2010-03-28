Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0C1BUl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 21:20:41 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:15507 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab0C1BUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 21:20:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:to:cc:in-reply-to:references;
        b=ONCtTT0zPpS98zTSWgwSDmAC2IdcoCssUW3J/aobAjIRDbjrYiBuarYOjlk6sVFJ+V
         qxi3te1Rmqi6+1XoEbiOwotFhfCdMy28X0Hf3rv5slSFRYAEPxdlr+9ul4LgpjBo2RVS
         GaIDZckBGNEdAOwIcWvif+PpQIwwICJU+NyAE=
Message-ID: <4baeaee5.c5c2f10a.7187.2688@mx.google.com>
Date: Sat, 27 Mar 2010 18:20:37 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, npiggin@suse.de, mingo@elte.hu,
       Ruald Andreae <ruald.a@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Olly Betts <olly@survex.com>, martin f krafft <madduck@madduck.net>
In-Reply-To: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all,

I have posted another profile[1] from an incident yesterday. As you can see,
both swapper and init (strange?) show up prominently in the profile. Moreover,
most processes seem to be in blk_peek_request a disturbingly large percentage
of the time. Both of these profiles were taken with 2.6.34-rc kernels.

Anyone have any ideas on how to proceed? Is more profile data necessary? Are
the existing profiles at all useful? Thanks,

- Ben
