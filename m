Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab1KOLMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 06:12:47 -0500
Received: from caiajhbdcagg.dreamhost.com ([208.97.132.66]:40495 "EHLO
	homiemail-a6.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755050Ab1KOLMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 06:12:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=jidanni.org; h=from:to:cc:subject
	:references:date:message-id:mime-version:content-type; q=dns; s=
	jidanni.org; b=Ce+M7cl+HFx7WlAzaP5+FEnegXrM3v3LW42Hs3xwHNd9g2F4/
	08tfCda4Qs9AYTWSi7FkCfvQa3zLXllvaAQojyiUuyaHrw0nw+uPteI9NDgPJpRk
	PAnaQWfTUCZemsfPXRhU63y8eZ+Zc6tjTKkAp8DpeRQo/Ym+96H4c/c3ic=
From: jidanni@jidanni.org
To: bernd@petrovitsch.priv.at
Cc: blp@cs.stanford.edu, linux-kernel@vger.kernel.org
Subject: Re: Documentation/input/input.txt.gz has a bug
References: <1321351772.22548.12.camel@thorin>
Date: Tue, 15 Nov 2011 19:12:42 +0800
Message-ID: <87ty65vdud.fsf@jidanni.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "BP" == Bernd Petrovitsch <bernd@petrovitsch.priv.at> writes:
BP> You plain simply copied too much (and the parentheses also make
BP> absolutely no sense for the "cat" command).
BP> /dev/input/mouse0 is a _c_haracter device with major number _13_ and
BP> minor number _32_.
Yes, but the document needs to make that fact clear, as there will be
all levels of readers reading it. Else it will look like part of the
command to some.
