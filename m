Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab2JIIBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 04:01:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48043 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab2JIIA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 04:00:56 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-55-5073d9b7fe8e
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Namjae Jeon'" <linkinjeon@gmail.com>
Cc: "'Vyacheslav Dubeyko'" <slava@dubeyko.com>,
        "'Marco Stornelli'" <marco.stornelli@gmail.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>, tytso@mit.edu,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com, linux-fsdevel@vger.kernel.org
References: <415E76CC-A53D-4643-88AB-3D7D7DC56F98@dubeyko.com>
 <9DE65D03-D4EA-4B32-9C1D-1516EAE50E23@dubeyko.com>
 <1349553966.12699.132.camel@kjgkr> <50712AAA.5030807@gmail.com>
 <002201cda46e$88b84d30$9a28e790$%kim@samsung.com>
 <F7EA5AF7-8A1C-4C98-90AF-9D47E39731AB@dubeyko.com>
 <004101cda52e$72210e20$56632a60$%kim@samsung.com>
 <CAKYAXd_Y0Y0kLyqEm1FVO5TpvrN-WwnF40H3hMe5B7_cTe0nMw@mail.gmail.com>
 <004a01cda542$f398e2c0$dacaa840$%kim@samsung.com>
 <CAKYAXd-YdpiM9GcAtoVbV=Wc_kzRkiXTWkNBvWaaYqU4Xks-jA@mail.gmail.com>
 <004c01cda54e$15cd4a60$4167df20$%kim@samsung.com>
 <CAKYAXd_08jWGrR=tDJyPo9HW6=5KwrqdOn-Z4yUDP5mnriMtYQ@mail.gmail.com>
In-reply-to: <CAKYAXd_08jWGrR=tDJyPo9HW6=5KwrqdOn-Z4yUDP5mnriMtYQ@mail.gmail.com>
Subject: RE: [PATCH 00/16] f2fs: introduce flash-friendly file system
Date: Tue, 09 Oct 2012 17:00:54 +0900
Message-id: <007001cda5f4$353c4d00$9fb4e700$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2l0XhhLDnhWOsrRL296iAeVEjR5gAIppHA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jAd3tN4sDDDbf47DYs/cki8XlXXPY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MqYvXISU8H+bsaKFb3LWRoYb2d2MXJySAiYSGyY/oEd
	whaTuHBvPVsXIxeHkMAiRonDk+azQzj/GCVmnDkL5HBwsAloS2zebwDSICKgIfFg+1awGmaB
	R0wSn/r/MUM09LNKdDduZAWp4hQIlnjQtZMJxBYWcJVo/9POCGKzCKhK/L/zlQ3E5hWwlVhy
	7SgjhC0o8WPyPRaQZcwC6hJTpuSChJmB9j55d4EVJCwBFH70VxfiBiOJ70va2SFKRCT2vXjH
	OIFRaBaSQbMQBs1CMmgWko4FjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJD+pn0DsZV
	DRaHGAU4GJV4eD9EFQcIsSaWFVfmHmKU4GBWEuG9nggU4k1JrKxKLcqPLyrNSS0+xCjNwaIk
	ztvskRIgJJCeWJKanZpakFoEk2Xi4JRqYAzb27F/9YTSKyd4tTdlf462da89+zy3Ztvmyn/Z
	/RuDA65GVZYXca2//3/VMlfuILWJn3+LHP/NoO0qZFPULPu0jMlEQ31Favafr9k5i+fmVvcF
	LG21a5i25o/Jx6nyt79nMoRPTevdsPFcVGwszwr1OvYdgidCt7FP4k6TX5YqEmL03cTvrRJL
	cUaioRZzUXEiAPh7MBVlAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



---
Jaegeuk Kim
Samsung


> -----Original Message-----
> From: Namjae Jeon [mailto:linkinjeon@gmail.com]
> Sent: Tuesday, October 09, 2012 12:52 PM
> To: Jaegeuk Kim
> Cc: Vyacheslav Dubeyko; Marco Stornelli; Jaegeuk Kim; Al Viro; tytso@mit.edu;
> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; chur.lee@samsung.com; cm224.lee@samsung.com;
> jooyoung.hwang@samsung.com; linux-fsdevel@vger.kernel.org
> Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system
> 
> 2012/10/8, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> >> -----Original Message-----
> >> From: Namjae Jeon [mailto:linkinjeon@gmail.com]
> >> Sent: Monday, October 08, 2012 8:22 PM
> >> To: Jaegeuk Kim
> >> Cc: Vyacheslav Dubeyko; Marco Stornelli; Jaegeuk Kim; Al Viro;
> >> tytso@mit.edu;
> >> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> >> chur.lee@samsung.com; cm224.lee@samsung.com;
> >> jooyoung.hwang@samsung.com; linux-fsdevel@vger.kernel.org
> >> Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system
> >>
> >> 2012/10/8, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> >> >> -----Original Message-----
> >> >> From: Namjae Jeon [mailto:linkinjeon@gmail.com]
> >> >> Sent: Monday, October 08, 2012 7:00 PM
> >> >> To: Jaegeuk Kim
> >> >> Cc: Vyacheslav Dubeyko; Marco Stornelli; Jaegeuk Kim; Al Viro;
> >> >> tytso@mit.edu;
> >> >> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> >> >> chur.lee@samsung.com; cm224.lee@samsung.com;
> >> >> jooyoung.hwang@samsung.com; linux-fsdevel@vger.kernel.org
> >> >> Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system
> >> >>
> >> >> 2012/10/8, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> >> >> >> -----Original Message-----
> >> >> >> From: Vyacheslav Dubeyko [mailto:slava@dubeyko.com]
> >> >> >> Sent: Sunday, October 07, 2012 9:09 PM
> >> >> >> To: Jaegeuk Kim
> >> >> >> Cc: 'Marco Stornelli'; 'Jaegeuk Kim'; 'Al Viro'; tytso@mit.edu;
> >> >> >> gregkh@linuxfoundation.org; linux-
> >> >> >> kernel@vger.kernel.org; chur.lee@samsung.com;
> >> >> >> cm224.lee@samsung.com;
> >> >> >> jooyoung.hwang@samsung.com;
> >> >> >> linux-fsdevel@vger.kernel.org
> >> >> >> Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file
> >> >> >> system
> >> >> >>
> >> >> >> Hi,
> >> >> >>
> >> >> >> On Oct 7, 2012, at 1:31 PM, Jaegeuk Kim wrote:
> >> >> >>
> >> >> >> >> -----Original Message-----
> >> >> >> >> From: Marco Stornelli [mailto:marco.stornelli@gmail.com]
> >> >> >> >> Sent: Sunday, October 07, 2012 4:10 PM
> >> >> >> >> To: Jaegeuk Kim
> >> >> >> >> Cc: Vyacheslav Dubeyko; jaegeuk.kim@samsung.com; Al Viro;
> >> >> >> >> tytso@mit.edu; gregkh@linuxfoundation.org;
> >> >> >> >> linux-kernel@vger.kernel.org; chur.lee@samsung.com;
> >> >> >> >> cm224.lee@samsung.com;
> >> >> >> jooyoung.hwang@samsung.com;
> >> >> >> >> linux-fsdevel@vger.kernel.org
> >> >> >> >> Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file
> >> >> >> >> system
> >> >> >> >>
> >> >> >> >> Il 06/10/2012 22:06, Jaegeuk Kim ha scritto:
> >> >> >> >>> 2012-10-06 (토), 17:54 +0400, Vyacheslav Dubeyko:
> >> >> >> >>>> Hi Jaegeuk,
> >> >> >> >>>
> >> >> >> >>> Hi.
> >> >> >> >>> We know each other, right? :)
> >> >> >> >>>
> >> >> >> >>>>
> >> >> >> >>>>> From:	 	김재극 <jaegeuk.kim@samsung.com>
> >> >> >> >>>>> To:	 	viro@zeniv.linux.org.uk, 'Theodore Ts'o'
> >> >> >> >>>>> <tytso@mit.edu>,
> >> >> >> >> gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
> >> >> >> >> chur.lee@samsung.com,
> >> >> >> cm224.lee@samsung.com,
> >> >> >> >> jaegeuk.kim@samsung.com, jooyoung.hwang@samsung.com
> >> >> >> >>>>> Subject:	 	[PATCH 00/16] f2fs: introduce flash-friendly file
> >> >> >> >>>>> system
> >> >> >> >>>>> Date:	 	Fri, 05 Oct 2012 20:55:07 +0900
> >> >> >> >>>>>
> >> >> >> >>>>> This is a new patch set for the f2fs file system.
> >> >> >> >>>>>
> >> >> >> >>>>> What is F2FS?
> >> >> >> >>>>> =============
> >> >> >> >>>>>
> >> >> >> >>>>> NAND flash memory-based storage devices, such as SSD, eMMC,
> >> >> >> >>>>> and
> >> >> >> >>>>> SD
> >> >> >> >>>>> cards, have
> >> >> >> >>>>> been widely being used for ranging from mobile to server
> >> >> >> >>>>> systems.
> >> >> >> >>>>> Since they are
> >> >> >> >>>>> known to have different characteristics from the conventional
> >> >> >> >>>>> rotational disks,
> >> >> >> >>>>> a file system, an upper layer to the storage device, should
> >> >> >> >>>>> adapt
> >> >> >> >>>>> to
> >> >> >> >>>>> the changes
> >> >> >> >>>>> from the sketch.
> >> >> >> >>>>>
> >> >> >> >>>>> F2FS is a new file system carefully designed for the NAND
> >> >> >> >>>>> flash
> >> >> >> >>>>> memory-based storage
> >> >> >> >>>>> devices. We chose a log structure file system approach, but
> >> >> >> >>>>> we
> >> >> >> >>>>> tried
> >> >> >> >>>>> to adapt it
> >> >> >> >>>>> to the new form of storage. Also we remedy some known issues
> >> >> >> >>>>> of
> >> >> >> >>>>> the
> >> >> >> >>>>> very old log
> >> >> >> >>>>> structured file system, such as snowball effect of wandering
> >> >> >> >>>>> tree
> >> >> >> >>>>> and high cleaning
> >> >> >> >>>>> overhead.
> >> >> >> >>>>>
> >> >> >> >>>>> Because a NAND-based storage device shows different
> >> >> >> >>>>> characteristics
> >> >> >> >>>>> according to
> >> >> >> >>>>> its internal geometry or flash memory management scheme aka
> >> >> >> >>>>> FTL,
> >> >> >> >>>>> we
> >> >> >> >>>>> add various
> >> >> >> >>>>> parameters not only for configuring on-disk layout, but also
> >> >> >> >>>>> for
> >> >> >> >>>>> selecting allocation
> >> >> >> >>>>> and cleaning algorithms.
> >> >> >> >>>>>
> >> >> >> >>>>
> >> >> >> >>>> What about F2FS performance? Could you share benchmarking
> >> >> >> >>>> results
> >> >> >> >>>> of
> >> >> >> >>>> the new file system?
> >> >> >> >>>>
> >> >> >> >>>> It is very interesting the case of aged file system. How is
> >> >> >> >>>> GC's
> >> >> >> >>>> implementation efficient? Could
> >> >> >> >> you share benchmarking results for the very aged file system
> >> >> >> >> state?
> >> >> >> >>>>
> >> >> >> >>>
> >> >> >> >>> Although I have benchmark results, currently I'd like to see
> >> >> >> >>> the
> >> >> >> >>> results
> >> >> >> >>> measured by community as a black-box. As you know, the results
> >> >> >> >>> are
> >> >> >> >>> very
> >> >> >> >>> dependent on the workloads and parameters, so I think it would
> >> >> >> >>> be
> >> >> >> >>> better
> >> >> >> >>> to see other results for a while.
> >> >> >> >>> Thanks,
> >> >> >> >>>
> >> >> >> >>
> >> >> >> >> 1) Actually it's a strange approach. If you have got any results
> >> >> >> >> you
> >> >> >> >> should share them with the community explaining how (the
> >> >> >> >> workload,
> >> >> >> >> hw
> >> >> >> >> and so on) your benchmark works and the specific condition. I
> >> >> >> >> really
> >> >> >> >> don't like the approach "I've got the results but I don't say
> >> >> >> >> anything,
> >> >> >> >> if you want a number, do it yourself".
> >> >> >> >
> >> >> >> > It's definitely right, and I meant *for a while*.
> >> >> >> > I just wanted to avoid arguing with how to age file system in
> >> >> >> > this
> >> >> >> > time.
> >> >> >> > Before then, I share the primitive results as follows.
> >> >> >> >
> >> >> >> > 1. iozone in Panda board
> >> >> >> > - ARM A9
> >> >> >> > - DRAM : 1GB
> >> >> >> > - Kernel: Linux 3.3
> >> >> >> > - Partition: 12GB (64GB Samsung eMMC)
> >> >> >> > - Tested on 2GB file
> >> >> >> >
> >> >> >> >           seq. read, seq. write, rand. read, rand. write
> >> >> >> > - ext4:    30.753         17.066       5.06         4.15
> >> >> >> > - f2fs:    30.71          16.906       5.073       15.204
> >> >> >> >
> >> >> >> > 2. iozone in Galaxy Nexus
> >> >> >> > - DRAM : 1GB
> >> >> >> > - Android 4.0.4_r1.2
> >> >> >> > - Kernel omap 3.0.8
> >> >> >> > - Partition: /data, 12GB
> >> >> >> > - Tested on 2GB file
> >> >> >> >
> >> >> >> >           seq. read, seq. write, rand. read,  rand. write
> >> >> >> > - ext4:    29.88        12.83         11.43          0.56
> >> >> >> > - f2fs:    29.70        13.34         10.79         12.82
> >> >> >> >
> >> >> >>
> >> >> >>
> >> >> >> This is results for non-aged filesystem state. Am I correct?
> >> >> >>
> >> >> >
> >> >> > Yes, right.
> >> >> >
> >> >> >>
> >> >> >> > Due to the company secret, I expect to show other results after
> >> >> >> > presenting f2fs at korea linux forum.
> >> >> >> >
> >> >> >> >> 2) For a new filesystem you should send the patches to
> >> >> >> >> linux-fsdevel.
> >> >> >> >
> >> >> >> > Yes, that was totally my mistake.
> >> >> >> >
> >> >> >> >> 3) It's not clear the pros/cons of your filesystem, can you
> >> >> >> >> share
> >> >> >> >> with
> >> >> >> >> us the main differences with the current fs already in mainline?
> >> >> >> >> Or
> >> >> >> >> is
> >> >> >> >> it a company secret?
> >> >> >> >
> >> >> >> > After forum, I can share the slides, and I hope they will be
> >> >> >> > useful
> >> >> >> > to
> >> >> >> > you.
> >> >> >> >
> >> >> >> > Instead, let me summarize at a glance compared with other file
> >> >> >> > systems.
> >> >> >> > Here are several log-structured file systems.
> >> >> >> > Note that, F2FS operates on top of block device with
> >> >> >> > consideration
> >> >> >> > on
> >> >> >> > the FTL behavior.
> >> >> >> > So, JFFS2, YAFFS2, and UBIFS are out-of scope, since they are
> >> >> >> > designed
> >> >> >> > for raw NAND flash.
> >> >> >> > LogFS is initially designed for raw NAND flash, but expanded to
> >> >> >> > block
> >> >> >> > device.
> >> >> >> > But, I don't know whether it is stable or not.
> >> >> >> > NILFS2 is one of major log-structured file systems, which
> >> >> >> > supports
> >> >> >> > multiple snap-shots.
> >> >> >> > IMO, that feature is quite promising and important to users, but
> >> >> >> > it
> >> >> >> > may
> >> >> >> > degrade the performance.
> >> >> >> > There is a trade-off between functionalities and performance.
> >> >> >> > F2FS chose high performance without any further fancy
> >> >> >> > functionalities.
> >> >> >> >
> >> >> >>
> >> >> >> Performance is a good goal. But fault-tolerance is also very
> >> >> >> important
> >> >> >> point. Filesystems are used by
> >> >> >> users, so, it is very important to guarantee reliability of data
> >> >> >> keeping.
> >> >> >> Degradation of performance
> >> >> >> by means of snapshots is arguable point. Snapshots can solve the
> >> >> >> problem
> >> >> >> not only some unpredictable
> >> >> >> environmental issues but also user's erroneous behavior.
> >> >> >>
> >> >> >
> >> >> > Yes, I agree. I concerned the multiple snapshot feature.
> >> >> > Of course, fault-tolerance is very important, and file system should
> >> >> > support
> >> >> > it as you know as power-off-recovery.
> >> >> > f2fs supports the recovery mechanism by adopting checkpoint similar
> >> >> > to
> >> >> > snapshot.
> >> >> > But, f2fs does not support multiple snapshots for user convenience.
> >> >> > I just focused on the performance, and absolutely, the multiple
> >> >> > snapshot
> >> >> > feature is also a good alternative approach.
> >> >> > That may be a trade-off.
> >> >> >
> >> >> >> As I understand, it is not possible to have a perfect performance
> >> >> >> in
> >> >> >> all
> >> >> >> possible workloads. Could you
> >> >> >> point out what workloads are the best way of F2FS using?
> >> >> >
> >> >> > Basically I think the following workloads will be good for F2FS.
> >> >> > - Many random writes : it's LFS nature
> >> >> > - Small writes with frequent fsync : f2fs is optimized to reduce the
> >> >> > fsync
> >> >> > overhead.
> >> >> >
> >> >> >>
> >> >> >> > Maybe or obviously it is possible to optimize ext4 or btrfs to
> >> >> >> > flash
> >> >> >> > storages.
> >> >> >> > IMHO, however, they are originally designed for HDDs, so that it
> >> >> >> > may
> >> >> >> > or
> >> >> >> > may not suffer from
> >> >> >> fundamental designs.
> >> >> >> > I don't know, but why not designing a new file system for flash
> >> >> >> > storages
> >> >> >> > as a counterpart?
> >> >> >> >
> >> >> >>
> >> >> >> Yes, it is possible. But F2FS is not flash oriented filesystem as
> >> >> >> JFFS2,
> >> >> >> YAFFS2, UBIFS but block-
> >> >> >> oriented filesystem. So, F2FS design is restricted by block-layer's
> >> >> >> opportunities in the using of
> >> >> >> flash storages' peculiarities. Could you point out key points of
> >> >> >> F2FS
> >> >> >> design that makes this design
> >> >> >> fundamentally unique?
> >> >> >
> >> >> > As you can see the f2fs kernel document patch, I think one of the
> >> >> > most
> >> >> > important features is to align operating units between f2fs and ftl.
> >> >> > Specifically, f2fs has section and zone, which are cleaning unit and
> >> >> > basic
> >> >> > allocation unit respectively.
> >> >> > Through these configurable units in f2fs, I think f2fs is able to
> >> >> > reduce
> >> >> > the
> >> >> > unnecessary operations done by FTL.
> >> >> > And, in order to avoid changing IO patterns by the block-layer, f2fs
> >> >> > merges
> >> >> > itself some bios likewise ext4.
> >> >> Hello.
> >> >> The internal of eMMC and SSD is the blackbox from user side.
> >> >> How does the normal user easily set operating units alignment(page
> >> >> size and physical block size ?) between f2fs and ftl in storage device
> >> >> ?
> >> >
> >> > I've known that some works have been tried to figure out the units by
> >> > profiling the storage, AKA reverse engineering.
> >> > In most cases, the simplest way is to measure the latencies of
> >> > consecutive
> >> > writes and analyze their patterns.
> >> > As you mentioned, in practical, users will not want to do this, so maybe
> >> > we
> >> > need a tool to profile them to optimize f2fs.
> >> > In the current state, I think profiling is an another issue, and
> >> > mkfs.f2fs
> >> > had better include this work in the future.
> >> Well, Format tool evaluates optimal block size whenever formatting? As
> >> you know, The size of Flash Based storage device is increasing every
> >> year. It means format time can be too long on larger devices(e.g. one
> >> device, one parition).
> >
> > Every file systems will suffer from the long format time in such a huge
> > device.
> > And, I don't think the profiling time would not be scaled up, since it's
> > unnecessary to scan whole device.
> > After getting the size, we just can stop it.
> The key point is that you should estimate correct optimal block size
> of ftl with much less I/O at format time.

Yes, exactly.

> I am not sure it is possible.

Why do you think like that?
As I tested before, I could see a kind of patterns when writing just several tens of MB on eMMC.

> And you should prove optimal block size is really correct on several
> device per vendor device.

Yes, it is correct, but unfortunately, I cannot prove for all the devices.
You're arguing about heuristic vs. optimal approaches.
IMHO, most file systems are based on a heuristic approach.
And f2fs also adopts a heuristic approach, which means it tries to help FTL as much as possible,
not cooperates with FTL directly.
Furthermore, even though the default unit size is not optimal, I believe that it can be well operated in most cases.
(Since most SSDs has 512KB of erase block size, so 2MB can cover 4-way SSDs.)

Thanks,

> 
> >
> >> > But, IMO, from the viewpoint of performance, default configuration is
> >> > quite
> >> > enough now.
> >> At default(after cleanly format), Would you share performance
> >> difference between other log structured filesystems in comparison to
> >> f2fs instead of ext4 ?
> >>
> >
> > Actually, we've focused on ext4, so I have no results of other file systems
> > measured on embedded systems.
> > I'll test sooner or later, and report them.
> Okay, Thanks Jaegeuk.
> 
> > Thank you for valuable comments.
> >
> >> Thanks.
> >> >
> >> > ps) f2fs doesn't care about the flash page size, but considers garbage
> >> > collection unit.
> >> >
> >> >>
> >> >> Thanks.
> >> >>
> >> >> >
> >> >> >>
> >> >> >> With the best regards,
> >> >> >> Vyacheslav Dubeyko.
> >> >> >>
> >> >> >>
> >> >> >> >>
> >> >> >> >> Marco
> >> >> >> >
> >> >> >> > ---
> >> >> >> > Jaegeuk Kim
> >> >> >> > Samsung
> >> >> >> >
> >> >> >> > --
> >> >> >> > To unsubscribe from this list: send the line "unsubscribe
> >> >> >> > linux-kernel"
> >> >> >> > in
> >> >> >> > the body of a message to majordomo@vger.kernel.org
> >> >> >> > More majordomo info at
> >> >> >> > http://vger.kernel.org/majordomo-info.html
> >> >> >> > Please read the FAQ at  http://www.tux.org/lkml/
> >> >> >
> >> >> >
> >> >> > ---
> >> >> > Jaegeuk Kim
> >> >> > Samsung
> >> >> >
> >> >> > --
> >> >> > To unsubscribe from this list: send the line "unsubscribe
> >> >> > linux-fsdevel"
> >> >> > in
> >> >> > the body of a message to majordomo@vger.kernel.org
> >> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> >> >
> >> >
> >> >
> >> > ---
> >> > Jaegeuk Kim
> >> > Samsung
> >> >
> >> >
> >> >
> >
> >
> > ---
> > Jaegeuk Kim
> > Samsung
> >
> >

