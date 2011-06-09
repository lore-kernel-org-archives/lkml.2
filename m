Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291Ab1FIEtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 00:49:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49058 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab1FIEtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 00:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=rUji7ic6eY/UD+JZNQR7QcVgwb9fCarmLlHRxoEIaWkvPXnGb1aFFAfD6n79Ss9j3e
         +1LoMROK5sCWriLG4wWvs+Vwp1z2PY1Y73pusvf/v/4nkqPZcZMGkXZEoPK4hcMJW7O1
         Xsb53WXonH7xqw3bPH+7vr7S++TLSB/GI6r5s=
MIME-Version: 1.0
In-Reply-To: <4DDBDB4D.4080606@gmail.com>
References: <4DDB491A.2070901@gmail.com>
	<BANLkTinC=2wxtYD4YmePgOfoLSh9STD6Sw@mail.gmail.com>
	<20110524155608.GA17977@redhat.com>
	<4DDBDB4D.4080606@gmail.com>
Date: Wed, 8 Jun 2011 21:49:09 -0700
Message-ID: <BANLkTind3R-kvWiM9DdGRkW8bwLo2p49mQ@mail.gmail.com>
Subject: Re: INFO: suspicious rcu_dereference_check() usage.
From: Justin Mattock <justinmattock@gmail.com>
To: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this fired off again.. fpasted dmesg.
http://fpaste.org/9bs4/
just pulled the laste Mainline will run and see, will send anything
forward if I see anything.
Note: I am off the lists at the moment due to a transistion, Cc's me
if anything.

-- 
Justin P. Mattock
