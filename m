Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab0DMLhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 07:37:14 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.35]:54371 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab0DMLhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 07:37:12 -0400
Message-ID: <4BC4572D.10502@ladisch.de>
Date: Tue, 13 Apr 2010 13:36:13 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Krishna Gopal <linuxkrishna@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Accessing peripheral register directly from userspace
References: <q2m68f510a71004121001v370509fftc6f4b86c4420b509@mail.gmail.com>
In-Reply-To: <q2m68f510a71004121001v370509fftc6f4b86c4420b509@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krishna Gopal wrote:
> Would there be any issues for optimization purpose I do a mmap to a
> peripheral register to directly access it from userspace ?

This means that userspace could access any register in the same page.

Usually this is done only with read-only pages and with devices that
are designed for this so that all accessible registers are 'safe'.


Regards,
Clemens
