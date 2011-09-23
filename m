Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab1IWG2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 02:28:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:31545 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab1IWG2G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 02:28:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=bZgz4kwRowhKpw5IIjZ0ywcf/qEoOcaHJrsP4VhpkmjNiTkqqSHktk0wzM0b1kvfv
	GhWjvKgikhuem8FntEq+Q==
MIME-Version: 1.0
In-Reply-To: <20110923032622.GS7761@one.firstfloor.org>
References: <20110922123128.GA9761@quad>
	<m2pqisjmtw.fsf@firstfloor.org>
	<CABPqkBTPF0Tqj5BEWanuh5=VYWjY_NuSLx1gAjPr3o1sbJB-JQ@mail.gmail.com>
	<20110923032622.GS7761@one.firstfloor.org>
Date: Fri, 23 Sep 2011 08:28:02 +0200
Message-ID: <CABPqkBQ-d2bKybG3GTg_jxgO_SGtP_LN-rPP9e3Q1NZ0=cT0Jw@mail.gmail.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v5)
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        mingo@elte.hu, dsahern@gmail.com, robert.richter@amd.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 5:26 AM, Andi Kleen <andi@firstfloor.org> wrote:
>>  * .byte 0x53 == push ebx. it's universal for 32 and 64 bit
>>  * .byte 0x5b == pop ebx.
>>  * Some gcc's (4.1.2 on Core2) object to pairing push/pop and ebx in
>> 64 bit mode.
>
> What do you mean with "object" ?
should read 'objects to' meaning 'refuses to'
