Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1JZXO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 19:14:56 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41902 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1JZXOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 19:14:54 -0400
MIME-Version: 1.0
In-Reply-To: <B4E6F7EB08816A4692C7420D7E8F8CBD16EC546E@ORSMSX101.amr.corp.intel.com>
References: <B4E6F7EB08816A4692C7420D7E8F8CBD16EC546E@ORSMSX101.amr.corp.intel.com>
Date: Thu, 27 Oct 2011 01:14:53 +0200
Message-ID: <CAFLxGvzDvd+jR2Tsv1XVBdfzo9GF5AgPD=wdkUoskyFhLUnj-g@mail.gmail.com>
Subject: Re: FATAL: kenrel too old - message
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: "Hebenstreit, Michael" <michael.hebenstreit@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 1:04 AM, Hebenstreit, Michael
<michael.hebenstreit@intel.com> wrote:
> Can someone explain me why even an ldd on a dynamic executable gives a "kernel too old"? I understand that linking to a gcc that does not support the kernel causes this problem at runtime, but why does ldd fail? Are there other ways to diagnose this?
>

Because ldd executes the binary to get it's dependencies.
It's just a bash script.

-- 
Thanks,
//richard
