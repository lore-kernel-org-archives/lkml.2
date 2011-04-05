Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1DENbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:31:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42031 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab1DENbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:31:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HUpkkrLhflzJfO9IKUhFWYxNXVOXr/F4PP2VIrejlWCmat2BZdTcD5D/s17vaM1W4a
         WioKBTc9eGoCoNa4zPmEy8xLK9bZlS4BsvzpN5oZ18ELtG0qU9QnjHnAkJef9B/n0w93
         ELFW7XTHnrsxh5BlfiQc2T/4/whFbveNHpef4=
MIME-Version: 1.0
In-Reply-To: <201103311704.40372.roucaries.bastien@gmail.com>
References: <201011181650.00152.roucaries.bastien@gmail.com>
	<AANLkTinp4=c9qmVyfocUk_ydJ3PV50b9UckNhJJNFsFm@mail.gmail.com>
	<AANLkTimYiRYZVXtxLBNeGcG=KVJTTiaGn+XGYP2Y=XMo@mail.gmail.com>
	<201103311704.40372.roucaries.bastien@gmail.com>
Date: Tue, 5 Apr 2011 15:30:58 +0200
Message-ID: <BANLkTikmtyyMes84rED5wpMxuN8kL91jEw@mail.gmail.com>
Subject: Re: Reiserfs deadlock in 2.6.36
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, jeffm@suse.com,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping ? You said on bugzilla it is related to acl but see nothing


On Thu, Mar 31, 2011 at 5:04 PM, Bastien ROUCARIES
<roucaries.bastien@gmail.com> wrote:
> Le lundi 28 mars 2011 11:14:28, Bastien ROUCARIES a écrit :
>> On Tue, Mar 8, 2011 at 4:22 PM, Bastien ROUCARIES
>>
>> <roucaries.bastien@gmail.com> wrote:
>> > On Tue, Mar 8, 2011 at 3:18 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> >> On Sun, Jan 30, 2011 at 01:08:29AM +0100, Bastien ROUCARIES wrote:
>> >>> Le jeudi 23 décembre 2010 04:42:33, Frederic Weisbecker a écrit :
>> >>> Hi,
>> >>>
>> >>> I take me more than two days of testing to reporduce this bugs with
>> >>> trace enabled. My filesystem was quite slow and this bugs seems to be
>> >>> timing related.
>>
>> Any news of this bug? Could I do something to help ?
>>
>> bastien
>>
>> > Ok bastien
>
