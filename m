Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab0DLJMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 05:12:12 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:38396 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab0DLJML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 05:12:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=M2RQ30Z/cTsrMjCbc5sS9Zr1+lHwtT/6ghhqwyijmcEE3RYDSXqcr5Z7sOQuNAI5mh
         aaNFWyWkcUOrH+xsptaaWwcQwIcFn8eu28MD8kN2Mm+Y7/kOkAL/c0BgplDQjNZpKXK7
         hgl8icdhMm4HXF5UJ6CtaIjn974pfzmhWabQE=
MIME-Version: 1.0
In-Reply-To: <20100412015714.GA2815@localhost.localdomain>
References: <20100412015714.GA2815@localhost.localdomain>
Date: Mon, 12 Apr 2010 10:12:09 +0100
Message-ID: <v2gfbd9d3991004120212jffcf0d20gad2df9d789982d92@mail.gmail.com>
Subject: Re: [PATCH] KVM: Enhance the coalesced_mmio_write() parameter to 
	avoid stack buffer overflow
From: Stefan Hajnoczi <stefanha@gmail.com>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
       kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does len need to be int?  Perhaps it should be unsigned int?

Stefan
