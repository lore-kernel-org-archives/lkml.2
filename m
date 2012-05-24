Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005Ab2EXDMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 23:12:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33379 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab2EXDMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 23:12:41 -0400
MIME-Version: 1.0
In-Reply-To: <20120524021429.GB12557@kroah.com>
References: <CACVXFVOUmFvEoADMQoc1S4vcW80v1efNvX=eHJheQTZzkcV9gA@mail.gmail.com>
	<Pine.LNX.4.44L0.1205231104540.1566-100000@iolanthe.rowland.org>
	<CACVXFVMqWyT78h53WnLuMYuhfFK-sbGMkS+T8SjWad6kQVFGTw@mail.gmail.com>
	<20120524021429.GB12557@kroah.com>
Date: Thu, 24 May 2012 11:12:34 +0800
Message-ID: <CACVXFVOwHZ=MEw5qsxS7pZ3QV56mXuS8xoG13hP9Xh8CggmHdA@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_Race_condition_between_driver=5Fprobe=5Fdevice_and_d?=
	=?UTF-8?Q?evice=5Fshutdown=E2=80=8F?=
From: Ming Lei <ming.lei@canonical.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux PM List <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 10:14 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> How about waiting for the original poster to respond as to exactly how
> they are hitting this race before doing anything?

Sure, :-)


Thanks,
--
Ming Lei
