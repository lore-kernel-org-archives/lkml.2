Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab1DFQZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 12:25:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64426 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab1DFQZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 12:25:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wxCij1WbuK4fJlo6hNr+L+Tb6jbqQ+ZWuZBzx9yHZFVAe3ydnx377KzYC2EBV0ic+7
         SuhgO0fPRUKo5jxZMvnV1SKlB76i/yZtT7oIUVmHWsh0cS3WS3MotNdp5E8sxl3WF7vO
         +8LLa5j0rPD/K8POQYIAsI5FkniEBs/oLmv1o=
MIME-Version: 1.0
In-Reply-To: <4D9C1842.6000602@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
	<1302015561-21047-2-git-send-email-mmarek@suse.cz>
	<BANLkTinwKzasKmB_fFzXd+W7F6GGuPO6+g@mail.gmail.com>
	<4D9C1842.6000602@suse.cz>
Date: Wed, 6 Apr 2011 12:25:35 -0400
Message-ID: <BANLkTi=dCYQcAk8ezF6V_uY7BMEyNAFUTQ@mail.gmail.com>
Subject: Re: [PATCH 01/34] kconfig: Do not record timestamp in auto.conf and autoconf.h
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 6, 2011 at 3:37 AM, Michal Marek <mmarek@suse.cz> wrote:
> On 5.4.2011 20:57, Arnaud Lacombe wrote:
>> Hi,
>>
>> On Tue, Apr 5, 2011 at 10:58 AM, Michal Marek <mmarek@suse.cz> wrote:
>>> Timestamps in file data are useless and there is already one in .config
>>>
>> hum, shouldn't this be tunable via KCONFIG_NOTIMESTAMP ? This might be
>> useful to know when the file was generated, independently of the
>> .config, as conf_write() and conf_write_autoconf() are independent
>> from one another.
>
> Yeah, but ls -l include/generated/autoconf.h will tell you the same,
> won't it?
>
Not if the file is spread to other machine/fs. Not that I care much
though, but for consistency, either KCONFIG_NOTIMESTAMP is honored in
every places where timestamps are used, or it should be killed
altogether.

 - Arnaud
