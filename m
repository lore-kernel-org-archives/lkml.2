Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab2AKIjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 03:39:05 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63348 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab2AKIjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 03:39:04 -0500
Subject: Re: aacraid question: is maximum_num_containers supposed to be minimum?
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <20120111082842.GA31452@elgon.mountain>
Date: Wed, 11 Jan 2012 03:38:55 -0500
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
        Haogang Chen <haogangchen@gmail.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <8654A042-17CA-4C02-8F34-554ED55B34F4@gmail.com>
References: <20120111082842.GA31452@elgon.mountain>
To: Dan Carpenter <dan.carpenter@oracle.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 11, 2012, at 3:28 AM, Dan Carpenter wrote:
> MAXIMUM_NUM_CONTAINERS is consistently used as a minimum not a maximum
> so I was wondering what was up with that?  This is ancient code that
> predates git.

Check out some early discussion. ;-)

https://lkml.org/lkml/2011/12/3/85

- xi
